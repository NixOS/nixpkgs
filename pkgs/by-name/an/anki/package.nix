{
  lib,
  stdenv,

  writableTmpDirAsHomeHook,
  cargo,
  fetchFromGitHub,
  installShellFiles,
  lame,
  mpv-unwrapped,
  ninja,
  callPackage,
  nixosTests,
  nodejs,
  jq,
  protobuf_31,
  python3,
  python3Packages,
  qt6,
  rsync,
  rustPlatform,
  uv,
  writeShellScriptBin,
  yarn,
  yarn-berry_4,
  runCommand,

  wrapGAppsHook3,

  swift,

  mesa,
  imagemagick,
}:

let
  yarn-berry = yarn-berry_4;

  pname = "anki";
  version = "25.09.2";
  rev = "3890e12c9e48c028c3f12aa58cb64bd9f8895e30";

  srcHash = "sha256-0hLTQR7f7s58DUgAZbDeREMee6VrqAKHyhS1Hs/Em1A=";
  cargoHash = "sha256-qcB+r9VzBz6ACZaXPL26MOxxtb/h2OIuxyc54vUgfPM=";
  yarnHash = "sha256-EmKeHORr/+qsDzAwtearMi7qodcCgjeAQcy+79HL7Vg=";
  pythonDeps =
    with python3Packages;
    [
      # anki (pylib) runtime deps
      decorator
      distro
      markdown
      orjson
      protobuf
      requests
      typing-extensions

      # aqt runtime deps
      beautifulsoup4
      flask
      flask-cors
      jsonschema
      pip-system-certs
      pyqt6
      pyqt6-sip
      pyqt6-webengine
      send2trash
      waitress

      # build-system deps (needed by uv for editable installs)
      editables
      hatchling
      pathspec
      pluggy
      setuptools
      trove-classifiers

      # transitive deps
      attrs
      blinker
      certifi
      charset-normalizer
      click
      idna
      itsdangerous
      jinja2
      jsonschema-specifications
      markupsafe
      packaging
      pip
      pysocks
      referencing
      rpds-py
      soupsieve
      urllib3
      werkzeug
      wrapt
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      anki-audio
      anki-mac-helper
    ];

  src = fetchFromGitHub {
    owner = "ankitects";
    repo = "anki";
    tag = version;
    hash = srcHash;
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = cargoHash;
  };

  # a wrapper for yarn to skip 'install'
  # We do this because we need to patchShebangs after install, so we do it
  # ourselves beforehand.
  # We also, confusingly, have to use yarn-berry to handle the lockfile (anki's
  # lockfile is too new for yarn), but have to use 'yarn' here, because anki's
  # build system uses yarn-1 style flags and such.
  # I think what's going on here is that yarn-1 in anki's normal build system
  # ends up noticing the yarn-file is too new and shelling out to yarn-berry
  # itself.
  noInstallYarn = writeShellScriptBin "yarn" ''
    [[ "$1" == "install" ]] && exit 0
    exec ${yarn}/bin/yarn "$@"
  '';

  uvWheels = runCommand "uv-wheels" { } (
    ''
      mkdir -p $out
    ''
    + (lib.strings.concatMapStringsSep "\n" (dep: "ln -vsf ${dep.dist}/*.whl $out") pythonDeps)
  );
in

python3Packages.buildPythonApplication (finalAttrs: {
  pyproject = false;
  inherit pname version;

  outputs = [
    "out"
    "doc"
    "man"
    "lib"
  ];

  inherit src;

  patches = [
    ./patches/disable-auto-update.patch
    ./patches/remove-the-gl-library-workaround.patch
    ./patches/skip-formatting-python-code.patch
    # Used in with-addons.nix
    ./patches/allow-setting-addons-folder.patch
  ];

  inherit cargoDeps;

  missingHashes = ./missing-hashes.json;
  yarnOfflineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) missingHashes;
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = yarnHash;
  };

  nativeBuildInputs = [
    uv
    cargo
    installShellFiles
    jq
    ninja
    nodejs
    python3Packages.mypy-protobuf
    qt6.wrapQtAppsHook
    rsync
    rustPlatform.cargoSetupHook
    writableTmpDirAsHomeHook
    yarn-berry_4.yarnBerryConfigHook
    imagemagick
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin swift
  # Needed for when Qt uses a system's GTK file picker.
  ++ lib.optional stdenv.hostPlatform.isLinux wrapGAppsHook3;

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwebengine
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux qt6.qtwayland;

  nativeCheckInputs = with python3Packages; [
    pytest
    mock
    astroid
  ];

  # tests fail with too many open files
  # TODO: verify if this is still true (I can't, no mac)
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkFlags = [
    # this test is flaky, see https://github.com/ankitects/anki/issues/3619
    # also remove from anki-sync-server when removing this
    "--skip=deckconfig::update::test::should_keep_at_least_one_remaining_relearning_step"
  ];

  dontUseNinjaInstall = false;
  dontWrapQtApps = true;
  dontWrapGApps = stdenv.hostPlatform.isLinux;

  env = {
    # Activate optimizations
    RELEASE = true;

    # https://github.com/ankitects/anki/blob/24.11/docs/linux.md#packaging-considerations
    OFFLINE_BUILD = "1";
    NODE_BINARY = lib.getExe nodejs;
    PROTOC_BINARY = lib.getExe protobuf_31;
    PYTHON_BINARY = lib.getExe python3;
    UV_BINARY = lib.getExe uv;
    UV_NO_MANAGED_PYTHON = "1";
    UV_SYSTEM_PYTHON = true;
    UV_PYTHON_DOWNLOADS = "never";
    UV_OFFLINE = "1";
    UV_FIND_LINKS = "${uvWheels}";
  };

  buildPhase = ''
    export RUST_BACKTRACE=1
    export RUST_LOG=debug

    mkdir -p out/pylib/anki .git

    echo ${builtins.substring 0 8 rev} > out/buildhash
    echo ${python3.version} > .python-version

    # Setup the python environment.
    # We use nixpkgs python packages (via UV_FIND_LINKS), whose versions may
    # differ from the uv.lock pins. Strip version constraints so uv accepts
    # whatever version is available.
    strip_versions() { sed 's/==[0-9][^ ;]*//g'; }
    mkdir -p ./out/pyenv
    uv export --no-dev | strip_versions > requirements.txt
    uv pip install --prefix ./out/pyenv -r requirements.txt
    # pyqt6-qt6 and pyqt6-webengine-qt6 are C++ Qt runtimes provided by the
    # system, not Python packages, so exclude them from resolution.
    uv export --project qt --extra qt --extra audio \
      --no-emit-package "pyqt6-qt6" \
      --no-emit-package "pyqt6-webengine-qt6" \
      | strip_versions > requirements.txt
    uv pip install --prefix ./out/pyenv -r requirements.txt
    uv export --project pylib | strip_versions > requirements.txt
    uv pip install --prefix ./out/pyenv -r requirements.txt

    # anki's build tooling expects python and protoc-gen-mypy in pyenv
    mkdir -p ./out/pyenv/bin
    ln -sf $PYTHON_BINARY ./out/pyenv/bin/python
    ln -sf ${lib.getExe python3Packages.mypy-protobuf} ./out/pyenv/bin/protoc-gen-mypy

    mv node_modules out

    # And finally build
    patchShebangs ./ninja

    export PYTHONPATH=$PYTHONPATH:$PWD/out/pyenv/${python3.sitePackages}
    # Necessary for yarn to not complain about 'corepack'
    jq 'del(.packageManager)' package.json > package.json.tmp && mv package.json.tmp package.json
    YARN_BINARY="${lib.getExe noInstallYarn}" PIP_USER=1 \
      ./ninja build wheels
  '';

  # mimic https://github.com/ankitects/anki/blob/76d8807315fcc2675e7fa44d9ddf3d4608efc487/build/ninja_gen/src/python.rs#L232-L250
  checkPhase =
    let
      disabledTestsString =
        lib.pipe
          [
            # assumes / is not writeable, somehow fails on nix-portable brwap
            "test_create_open"
          ]
          [
            (lib.map (test: "not ${test}"))
            (lib.concatStringsSep " and ")
            lib.escapeShellArg
          ];

    in
    ''
      runHook preCheck
      export PYTHONPATH=$PYTHONPATH:$PWD/out/pyenv/${python3.sitePackages}
      HOME=$TMP ANKI_TEST_MODE=1 PYTHONPATH=$PYTHONPATH:$PWD/out/pylib \
        pytest -p no:cacheprovider pylib/tests -k ${disabledTestsString}
      HOME=$TMP ANKI_TEST_MODE=1 PYTHONPATH=$PYTHONPATH:$PWD/out/pylib:$PWD/pylib:$PWD/out/qt \
        pytest -p no:cacheprovider qt/tests -k ${disabledTestsString}
      runHook postCheck
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $lib $out
    uv pip install out/wheels/*.whl --prefix $lib
    # remove non-anki bins from dependencies
    find $lib/bin -type f ! -name "anki*" -delete
    # and put bin into $out so people can access it. Leave $lib separate to avoid collisions, see
    # https://github.com/NixOS/nixpkgs/issues/438598
    mv $lib/bin $out/bin

    install -D -t $out/share/applications qt/launcher/lin/anki.desktop
    install -D -t $doc/share/doc/anki README* LICENSE*
    install -D -t $out/share/mime/packages qt/launcher/lin/anki.xml

    mkdir -p $out/share/icons/hicolor/{32x32,128x128}/apps
    magick qt/launcher/lin/anki.xpm $out/share/icons/hicolor/32x32/apps/anki.png
    magick qt/launcher/lin/anki.png -resize 128x128 $out/share/icons/hicolor/128x128/apps/anki.png
    installManPage qt/launcher/lin/anki.1

    runHook postInstall
  '';

  preFixup = ''
    makeWrapperArgs+=(
      ${lib.optionalString stdenv.hostPlatform.isLinux ''"''${gappsWrapperArgs[@]}"''}
      "''${qtWrapperArgs[@]}"
      --prefix PATH ':' "${lame}/bin:${mpv-unwrapped}/bin"
      --prefix PYTHONPATH ':' "$lib/${python3.sitePackages}"
    )
  '';

  passthru = {
    withAddons = ankiAddons: callPackage ./with-addons.nix { inherit ankiAddons; };
    tests.anki-sync-server = nixosTests.anki-sync-server;
  };

  meta = {
    description = "Spaced repetition flashcard program";
    mainProgram = "anki";
    longDescription = ''
      Anki is a program which makes remembering things easy. Because it is a lot
      more efficient than traditional study methods, you can either greatly
      decrease your time spent studying, or greatly increase the amount you learn.

      Anyone who needs to remember things in their daily life can benefit from
      Anki. Since it is content-agnostic and supports images, audio, videos and
      scientific markup (via LaTeX), the possibilities are endless. For example:
      learning a language, studying for medical and law exams, memorizing
      people's names and faces, brushing up on geography, mastering long poems,
      or even practicing guitar chords!
    '';
    homepage = "https://apps.ankiweb.net";
    license = lib.licenses.agpl3Plus;
    inherit (mesa.meta) platforms;
    maintainers = with lib.maintainers; [
      euank
      junestepp
      oxij
    ];
  };
})
