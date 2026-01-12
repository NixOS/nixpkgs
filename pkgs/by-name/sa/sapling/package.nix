{
  lib,
  stdenv,
  python312Packages,
  fetchFromGitHub,
  cargo,
  curl,
  gettext,
  libclang,
  pkg-config,
  openssl,
  rustPlatform,
  rustc,
  fetchYarnDeps,
  yarn,
  nodejs,
  fixup-yarn-lock,
  glibcLocales,
  libiconv,
  versionCheckHook,

  enableMinimal ? false,
}:

let
  version = "0.2.20250521-115337+25ed6ac4";

  # Sapling sets a Cargo config containing lines like so:
  # [target.aarch64-apple-darwin]
  # rustflags = ["-C", "link-args=-Wl,-undefined,dynamic_lookup"]
  #
  # The default cargo config that's set by the build hook will set
  # unstable.host-config and unstable.target-applies-to-host which seems to
  # result in the link arguments above being ignored and thus link failures.
  # All it is there to do anyway is just to do stuff with musl and cross
  # compilation, which doesn't work on macOS anyway so we can just stub it
  # on macOS.
  #
  # See https://github.com/NixOS/nixpkgs/pull/198311#issuecomment-1326894295
  myCargoSetupHook = rustPlatform.cargoSetupHook.overrideAttrs (old: {
    cargoConfig = lib.optionalString (!stdenv.hostPlatform.isDarwin) old.cargoConfig;
  });

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "sapling";
    tag = version;
    hash = "sha256-NvfSx6BMbwOFY+y6Yb/tyUNYeuL8WCoc+HSVys8Ko0Y=";
  };

  addonsSrc = "${src}/addons";

  # Fetches the Yarn modules in Nix to to be used as an offline cache
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${addonsSrc}/yarn.lock";
    sha256 = "sha256-9l4lSzFTF5rSByO388tosJCxOb65Nnua6HaDD7F62No=";
  };

  # Builds the NodeJS server that runs with `sl web`
  isl = stdenv.mkDerivation {
    pname = "sapling-isl";
    src = addonsSrc;
    inherit version;

    nativeBuildInputs = [
      fixup-yarn-lock
      nodejs
      yarn
    ];

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      fixup-yarn-lock yarn.lock
      yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
      yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
      patchShebangs node_modules
      patchShebangs isl/node_modules

      substituteInPlace build-tar.py \
        --replace-fail 'run(yarn + ["--cwd", src_join(), "install", "--prefer-offline"])' 'pass'

      ${python312Packages.python}/bin/python3 build-tar.py \
        --output isl-dist.tar.xz \
        --yarn 'yarn --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress'

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      install isl-dist.tar.xz $out/isl-dist.tar.xz

      runHook postInstall
    '';
  };
in
# Builds the main `sl` binary and its Python extensions
python312Packages.buildPythonApplication {
  format = "setuptools";
  pname = "sapling";
  inherit src version;

  sourceRoot = "${src.name}/eden/scm";

  # Upstream does not commit Cargo.lock
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "abomonation-0.7.3+smallvec1" = "sha256-AxEXR6GC8gHjycIPOfoViP7KceM29p2ZISIt4iwJzvM=";
      "cloned-0.1.0" = "sha256-026OKsszbF2aPWpA8JBc6KwZHxEqwnKIluzDjO/opgc=";
      "fb303_core-0.0.0" = "sha256-IJKAWgBLrLnWItw6UTNdwjuTDO6dUfqyKsVv2aW6Kyo=";
      "fbthrift-0.0.1+unstable" = "sha256-FuUo1cZG7Ed+TAXY53MpylBPGzFruIsWaxKPR26TxVk=";
      "serde_bser-0.4.0" = "sha256-OY+IZh4nz5ICrDKYr8pPfORW4i8KBULhGC5YyXb5Ulg=";
      "watchman_client-0.9.0" = "sha256-OY+IZh4nz5ICrDKYr8pPfORW4i8KBULhGC5YyXb5Ulg=";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock

    substituteInPlace sapling/thirdparty/pysocks/setup.py \
      --replace-fail 'os.path.dirname(__file__)' "\"$out/lib/${python312Packages.python.libPrefix}/site-packages/sapling/thirdparty/pysocks\""
  ''
  + lib.optionalString (!enableMinimal) ''
    # If asked, we optionally patch in a hardcoded path to the
    # 'nodejs' package, so that 'sl web' always works. Without the
    # patch, 'sl web' will still work if 'nodejs' is in $PATH.
    substituteInPlace lib/config/loader/src/builtin_static/core.rs \
      --replace '"#);' $'[web]\nnode-path=${nodejs}/bin/node\n"#);'
  '';

  postInstall = ''
    install ${isl}/isl-dist.tar.xz $out/lib/isl-dist.tar.xz
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/sl \
      --set LOCALE_ARCHIVE "${glibcLocales}/lib/locale/locale-archive"
  '';

  nativeBuildInputs = [
    curl
    pkg-config
    myCargoSetupHook
    cargo
    rustc
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ gettext ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
    libiconv
  ];

  HGNAME = "sl";
  LIBCLANG_PATH = "${lib.getLib libclang}/lib";
  SAPLING_OSS_BUILD = "true";
  SAPLING_VERSION = version;
  SAPLING_VERSION_HASH =
    let
      sha1Hash = builtins.hashString "sha1" version;
      hexSubstring = builtins.substring 0 16 sha1Hash;
    in
    lib.trivial.fromHexString hexSubstring;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru = {
    # Expose isl to nix repl as sapling.isl.
    isl = isl;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Scalable, User-Friendly Source Control System";
    homepage = "https://sapling-scm.com";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      pbar
      thoughtpolice
      shikanime
    ];
    platforms = lib.platforms.unix;
    mainProgram = "sl";
  };
}
