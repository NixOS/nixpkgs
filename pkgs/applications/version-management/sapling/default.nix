{ lib, stdenv, python3Packages, fetchFromGitHub, fetchurl, sd, curl, pkg-config, openssl, rustPlatform, fetchYarnDeps, yarn, nodejs, fixup_yarn_lock, glibcLocales }:

let
  inherit (lib.importJSON ./deps.json) links version versionHash;

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "sapling";
    rev = version;
    hash = "sha256-IzbUaFrsSMojhsbpnRj1XLkhO9V2zYdmmZls4mtZquw=";
  };

  addonsSrc = "${src}/addons";

  # Fetches the Yarn modules in Nix to to be used as an offline cache
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${addonsSrc}/yarn.lock";
    sha256 = "sha256-B61T0ReZPRfrRjBC3iHLVkVYiifhzOXlaG1YL6rgmj4=";
  };

  # Builds the NodeJS server that runs with `sl web`
  isl = stdenv.mkDerivation {
    pname = "sapling-isl";
    src = addonsSrc;
    inherit version;

    nativeBuildInputs = [
      fixup_yarn_lock
      nodejs
      yarn
    ];

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      fixup_yarn_lock yarn.lock
      yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
      yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
      patchShebangs node_modules

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cd isl
      node release.js $out

      runHook postInstall
    '';
  };

  # Builds the main `sl` binary and its Python extensions
  sapling = python3Packages.buildPythonPackage {
    pname = "sapling-main";
    inherit src version;

    sourceRoot = "source/eden/scm";

    # Upstream does not commit Cargo.lock
    cargoDeps = rustPlatform.importCargoLock {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "cloned-0.1.0" = "sha256-c3CPWVjOk+VKBLD6WuaYZvBoKi5PwgXmiwxKoCk0bsI=";
        "deltae-0.3.0" = "sha256-a9Skaqs+tVTw8x83jga+INBr+TdaMmo35Bf2wbfR6zs=";
        "fb303_core-0.0.0" = "sha256-yoKKSBwqufFayLef2rRpX5oV1j8fL/kRkXBXIC++d7Q=";
        "fbthrift-0.0.1+unstable" = "sha256-jtsDE5U/OavDUXRAE1N8/nujSPrWltImsFLzHaxfeM0=";
        "reqwest-0.11.11" = "sha256-uhc8XhkGW22XDNo0qreWdXeFF2cslOOZHfTRQ30IBcE=";
        "serde_bser-0.3.1" = "sha256-KCAC+rbczroZn/oKYTVpAPJl40yMrszt/PGol+JStDU=";
      };
    };
    postPatch = ''
      cp ${./Cargo.lock} Cargo.lock
    '';

    # Since the derivation builder doesn't have network access to remain pure,
    # fetch the artifacts manually and link them. Then replace the hardcoded URLs
    # with filesystem paths for the curl calls.
    postUnpack = ''
      mkdir $sourceRoot/hack_pydeps
      ${lib.concatStrings (map (li: "ln -s ${fetchurl li} $sourceRoot/hack_pydeps/${baseNameOf li.url}\n") links)}
      sed -i "s|https://files.pythonhosted.org/packages/[[:alnum:]]*/[[:alnum:]]*/[[:alnum:]]*/|file://$NIX_BUILD_TOP/$sourceRoot/hack_pydeps/|g" $sourceRoot/setup.py
    '';

    postFixup = ''
      wrapProgram $out/bin/sl \
        --set LOCALE_ARCHIVE "${glibcLocales}/lib/locale/locale-archive"
    '';

    nativeBuildInputs = [
      curl
      pkg-config
    ] ++ (with rustPlatform; [
      cargoSetupHook
      rust.cargo
      rust.rustc
    ]);

    buildInputs = [
      openssl
    ];

    doCheck = false;

    HGNAME = "sl";
    SAPLING_OSS_BUILD = "true";
    SAPLING_VERSION = version;
    SAPLING_VERSION_HASH = versionHash;
  };
in
stdenv.mkDerivation {
  pname = "sapling";
  inherit version;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -r ${sapling}/* $out

    sitepackages=$out/lib/${python3Packages.python.libPrefix}/site-packages
    chmod +w $sitepackages
    cp -r ${isl} $sitepackages/edenscm-isl

    runHook postInstall
  '';

  # just a simple check phase, until we have a running test suite. this should
  # help catch issues like lack of a LOCALE_ARCHIVE setting (see GH PR #202760)
  doCheck = true;
  checkPhase = ''
    echo -n "testing sapling version; should be \"${version}\"... "
    ${sapling}/bin/sl version | grep -qw "${version}"
    echo "OK!"
  '';

  meta = with lib; {
    description = "A Scalable, User-Friendly Source Control System";
    homepage = "https://sapling-scm.com";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pbar thoughtpolice ];
    platforms = platforms.linux;
    mainProgram = "sl";
  };
}
