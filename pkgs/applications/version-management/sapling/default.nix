{ lib
, stdenv
, python3Packages
, fetchFromGitHub
, fetchurl
, sd
, cargo
, curl
, pkg-config
, openssl
, rustPlatform
, rustc
, fetchYarnDeps
, yarn
, nodejs
, prefetch-yarn-deps
, glibcLocales
, libiconv
, Cocoa
, CoreFoundation
, CoreGraphics
, CoreServices
, Security
, WebKit

, enableMinimal ? false
}:

let
  inherit (lib.importJSON ./deps.json) links version versionHash;
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
    cargoConfig = lib.optionalString (!stdenv.isDarwin) old.cargoConfig;
  });

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "sapling";
    rev = version;
    hash = "sha256-+LxvPJkyq/6gtcBQepZ5pVGXP1/h30zhCHVfUGPUzFE=";
  };

  addonsSrc = "${src}/addons";

  # Fetches the Yarn modules in Nix to to be used as an offline cache
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${addonsSrc}/yarn.lock";
    sha256 = "sha256-3JFrVk78EiNVLLXkCFbuRnXwYHNfVv1pBPBS1yCHtPU=";
  };

  # Builds the NodeJS server that runs with `sl web`
  isl = stdenv.mkDerivation {
    pname = "sapling-isl";
    src = addonsSrc;
    inherit version;

    nativeBuildInputs = [
      prefetch-yarn-deps
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

      # TODO: build-tar.py tries to run 'yarn install'. We patched
      # shebangs node_modules, so we don't want 'yarn install'
      # changing files. We should disable the 'yarn install' in
      # build-tar.py to be safe.
      ${python3Packages.python}/bin/python3 build-tar.py \
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
python3Packages.buildPythonApplication {
  pname = "sapling";
  inherit src version;

  sourceRoot = "${src.name}/eden/scm";

  # Upstream does not commit Cargo.lock
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "abomonation-0.7.3+smallvec1" = "sha256-AxEXR6GC8gHjycIPOfoViP7KceM29p2ZISIt4iwJzvM=";
      "cloned-0.1.0" = "sha256-dtAyQq6fgxvr1RXPQHGiCQesvitsKpVkis4c50uolLc=";
      "fb303_core-0.0.0" = "sha256-j+4zPXxewRxJsPQaAfvcpSkGNKw3d+inVL45Ibo7Q4E=";
      "fbthrift-0.0.1+unstable" = "sha256-fsIL07PFu645eJFttIJU4sRSjIVuA4BMJ6kYAA0BpwY=";
      "serde_bser-0.3.1" = "sha256-h50EJL6twJwK90sBXu40Oap4SfiT4kQAK1+bA8XKdHw=";
    };
  };
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '' + lib.optionalString (!enableMinimal) ''
    # If asked, we optionally patch in a hardcoded path to the
    # 'nodejs' package, so that 'sl web' always works. Without the
    # patch, 'sl web' will still work if 'nodejs' is in $PATH.
    substituteInPlace lib/config/loader/src/builtin_static/core.rs \
      --replace '"#);' $'[web]\nnode-path=${nodejs}/bin/node\n"#);'
  '';

  # Since the derivation builder doesn't have network access to remain pure,
  # fetch the artifacts manually and link them. Then replace the hardcoded URLs
  # with filesystem paths for the curl calls.
  postUnpack = ''
    mkdir $sourceRoot/hack_pydeps
    ${lib.concatStrings (map (li: "ln -s ${fetchurl li} $sourceRoot/hack_pydeps/${baseNameOf li.url}\n") links)}
    sed -i "s|https://files.pythonhosted.org/packages/[[:alnum:]]*/[[:alnum:]]*/[[:alnum:]]*/|file://$NIX_BUILD_TOP/$sourceRoot/hack_pydeps/|g" $sourceRoot/setup.py
  '';

  postInstall = ''
    install ${isl}/isl-dist.tar.xz $out/lib/isl-dist.tar.xz
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/sl \
      --set LOCALE_ARCHIVE "${glibcLocales}/lib/locale/locale-archive"
  '';

  nativeBuildInputs = [
    curl
    pkg-config
    myCargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    curl
    libiconv
    Cocoa
    CoreFoundation
    CoreGraphics
    CoreServices
    Security
    WebKit
  ];

  HGNAME = "sl";
  SAPLING_OSS_BUILD = "true";
  SAPLING_VERSION_HASH = versionHash;

  # Python setuptools version 66 and newer does not support upstream Sapling's
  # version numbers (e.g. "0.2.20230124-180750-hf8cd450a"). Change the version
  # number to something supported by setuptools (e.g. "0.2.20230124").
  # https://github.com/facebook/sapling/issues/571
  SAPLING_VERSION = builtins.elemAt (builtins.split "-" version) 0;

  # just a simple check phase, until we have a running test suite. this should
  # help catch issues like lack of a LOCALE_ARCHIVE setting (see GH PR #202760)
  doCheck = true;
  installCheckPhase = ''
    echo -n "testing sapling version; should be \"$SAPLING_VERSION\"... "
    $out/bin/sl version | grep -qw "$SAPLING_VERSION"
    echo "OK!"
  '';

  # Expose isl to nix repl as sapling.isl.
  passthru.isl = isl;

  meta = with lib; {
    description = "A Scalable, User-Friendly Source Control System";
    homepage = "https://sapling-scm.com";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pbar thoughtpolice ];
    platforms = platforms.unix;
    mainProgram = "sl";
  };
}
