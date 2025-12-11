{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  cmake,
  pkg-config,
  catch2_3,
  ncurses,
  kdePackages,
  kissfftFloat,
  crossguid,
  reproc,
  platform-folders,
  ruby,
  beamPackages,
  alsa-lib,
  rtmidi,
  boost,
  aubio,
  jack2,
  jack-example-tools,
  pipewire,
  supercollider-with-sc3-plugins,
  parallel,

  withTauWidget ? false,

  withImGui ? false,
  gl3w,
  SDL2,
  fmt,
}@args:

let
  ruby = args.ruby.withPackages (ps: [
    ps.prime
    ps.racc
    ps.rake
    ps.rexml
  ]);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "sonic-pi";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "sonic-pi-net";
    repo = "sonic-pi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sF/ksVhUzSV5P3Oe/T8hAiFMFiuOMEPmuBlUZtPSvtk=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit (finalAttrs) version;
    pname = "mix-deps-sonic-pi";
    mixEnv = "test";
    src = "${finalAttrs.src}/app/server/beam/tau";
    hash = "sha256-UoETv6X/Q/RmKb0uCsu59DH7OF0H+A9e7+4uRM/B1Wk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    kdePackages.wrapQtAppsHook
    copyDesktopItems
    cmake
    pkg-config
    ruby
    beamPackages.erlang
    beamPackages.elixir
    beamPackages.hex
  ];

  buildInputs = [
    ncurses
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.qtwayland
    kdePackages.qwt
    kdePackages.qscintilla
    kissfftFloat
    catch2_3
    crossguid
    reproc
    platform-folders
    ruby
    alsa-lib
    rtmidi
    boost
    aubio
  ]
  ++ lib.optionals withTauWidget [
    kdePackages.qtwebengine
  ]
  ++ lib.optionals withImGui [
    gl3w
    SDL2
    fmt
  ];

  nativeCheckInputs = [
    parallel
    supercollider-with-sc3-plugins
    jack2
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_LIBS=ON"
    "-DBUILD_IMGUI_INTERFACE=${if withImGui then "ON" else "OFF"}"
    "-DWITH_QT_GUI_WEBENGINE=${if withTauWidget then "ON" else "OFF"}"
    "-DAPP_INSTALL_ROOT=${placeholder "out"}/app"
  ];

  doCheck = true;

  # Fix shebangs on files in app and bin scripts
  postPatch = ''
    patchShebangs app bin
  '';

  preConfigure =
    # Set build environment
    ''
      export SONIC_PI_HOME="$TMPDIR/spi"

      export HEX_HOME="$TEMPDIR/hex"
      export HEX_OFFLINE=1
      export MIX_REBAR3='${beamPackages.rebar3}/bin/rebar3'
      export REBAR_GLOBAL_CONFIG_DIR="$TEMPDIR/rebar3"
      export REBAR_CACHE_DIR="$TEMPDIR/rebar3.cache"
      export MIX_HOME="$TEMPDIR/mix"
      export MIX_DEPS_PATH="$TEMPDIR/deps"
      export MIX_ENV=prod
    ''
    # Copy Mix dependency sources
    + ''
      echo 'Copying ${finalAttrs.mixFodDeps} to Mix deps'
      cp --no-preserve=mode -R '${finalAttrs.mixFodDeps}' "$MIX_DEPS_PATH"
    ''
    # Change to project base directory
    + ''
      cd app
    ''
    # Prebuild Ruby vendored dependencies and Qt docs
    + ''
      ./linux-prebuild.sh -o
    '';

  # Build BEAM server
  postBuild = ''
    ../linux-post-tau-prod-release.sh -o
  '';

  checkPhase = ''
    runHook preCheck
  ''
  # BEAM tests
  + ''
    pushd ../server/beam/tau
    MIX_ENV=test TAU_ENV=test mix test
    popd
  ''
  # Ruby tests
  + ''
    pushd ../server/ruby
    rake test
    popd
  ''
  # API tests, run JACK parallel to tests and quit both when one exits
  + ''
    pushd api-tests
    SONIC_PI_ENV=test parallel --no-notice -j2 --halt now,done=1 ::: 'jackd -rd dummy' 'ctest --verbose'
    popd

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
  ''
  # Run Linux release script
  + ''
    ../linux-release.sh
  ''
  # Copy dist directory to output
  + ''
    mkdir $out
    cp -r linux_dist/* $out/
  ''
  # Copy icon
  + ''
    install -D --mode=0644 ../gui/images/icon-smaller.png $out/share/icons/hicolor/256x256/apps/sonic-pi.png

    runHook postInstall
  '';

  # $out/bin/sonic-pi is a shell script, and wrapQtAppsHook doesn't wrap them.
  dontWrapQtApps = true;
  preFixup = ''
    patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" $out/app/build/gui/sonic-pi
  ''
  # Wrap Qt GUI (distributed binary)
  + ''
    wrapQtApp $out/bin/sonic-pi \
      --prefix PATH : ${
        lib.makeBinPath [
          ruby
          supercollider-with-sc3-plugins
          jack2
          jack-example-tools
          pipewire.jack
        ]
      }
  ''
  # If ImGui was built, Wrap ImGui into bin
  + ''
    if [ -e $out/app/build/gui/imgui/sonic-pi-imgui ]; then
      makeWrapper $out/app/build/gui/imgui/sonic-pi-imgui $out/bin/sonic-pi-imgui \
        --inherit-argv0 \
        --prefix PATH : ${
          lib.makeBinPath [
            ruby
            supercollider-with-sc3-plugins
            jack2
            jack-example-tools
            pipewire.jack
          ]
        }
    fi
  ''
  # Remove runtime Erlang references
  + ''
    for file in $(grep -FrIl '${beamPackages.erlang}/lib/erlang' $out/app/server/beam/tau); do
      substituteInPlace "$file" --replace-fail '${beamPackages.erlang}/lib/erlang' $out/app/server/beam/tau/_build/prod/rel/tau
    done
  '';

  stripDebugList = [
    "app"
    "bin"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "sonic-pi";
      exec = "sonic-pi";
      icon = "sonic-pi";
      desktopName = "Sonic Pi";
      comment = finalAttrs.meta.description;
      categories = [
        "Audio"
        "AudioVideo"
        "Education"
      ];
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://sonic-pi.net/";
    description = "Free live coding synth for everyone originally designed to support computing and music lessons within schools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Phlogistique
      kamilchm
      c0deaddict
      sohalt
    ];
    platforms = lib.platforms.linux;
  };
})
