{
  lib,
  stdenv,
  python312Packages,
  fetchFromGitHub,
  cargo,
  curl,
  gettext,
  libclang,
  openssl,
  perl,
  pkg-config,
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
  version = "0.2.20260522-084851+1e764c94";

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
    hash = "sha256-Uqv3SCbiPTH8L+anlb2cUOm7gGmmD+SHALHvHpy5pfA=";
  };

  addonsSrc = "${src}/addons";

  # Clean the upstream yarn.lock completely before fetchYarnDeps parses it
  fixedYarnLock = stdenv.mkDerivation {
    name = "sapling-fixed-yarn-lock";
    src = addonsSrc;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      substitute yarn.lock $out/yarn.lock \
        --replace-fail "https://registry.facebook.net" "https://registry.npmjs.org"
    '';
  };

  # Fetches the Yarn modules in Nix to be used as an offline cache
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${fixedYarnLock}/yarn.lock";
    sha256 = "sha256-eS5NF3JAaKnlJkCKR9NpIDbMxaWpFXYEs45J5MTCRUI=";
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

      # Overwrite the build directory's lockfile with our fixed version
      # so that yarn install matches the offline cache exactly.
      cp ${fixedYarnLock}/yarn.lock yarn.lock

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
  cargoDeps = rustPlatform.fetchCargoVendor {
    pname = "sapling";
    inherit src version;
    cargoRoot = "eden/scm";
    postPatch = ''
      cp ${./Cargo.lock} eden/scm/Cargo.lock
    '';
    hash = "sha256-Uqv3SCbiPTH8L+anlb2cUOm7gGmmD+SHALHvHpy5pfA=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock

    # Remove [patch.crates-io] to prevent Cargo from fetching git repos in the sandbox
    sed -i '/^\[patch\.crates-io\]$/,/^$/d' Cargo.toml

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
    perl
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

  env = {
    HGNAME = "sl";
    LIBCLANG_PATH = "${lib.getLib libclang}/lib";
    OPENSSL_NO_VENDOR = "1";
    SAPLING_OSS_BUILD = "true";
    SAPLING_VERSION = version;
    SAPLING_VERSION_HASH =
      let
        sha1Hash = builtins.hashString "sha1" version;
        hexSubstring = builtins.substring 0 16 sha1Hash;
      in
      lib.trivial.fromHexString hexSubstring;
  };

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
