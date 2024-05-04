{ lib
, stdenv
, fetchFromGitHub
, python3
, fetchYarnDeps
, yarn
, nodejs
, prefetch-yarn-deps
, fixup-yarn-lock
, nodePackages
, substituteAll
, bash
, coreutils
, libfaketime
, gvisor
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "grist-core";
  version = "1.1.13";

  src = fetchFromGitHub {
    owner = "gristlabs";
    repo = "grist-core";
    rev = "v${version}";
    hash = "sha256-lLXgTVhztFGnfrMxks05T8dfE6CH4p/0j8lPieBRGTY=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-cbkykydPfIrlCxaLfdIFseBuNVUtIqPpLR2J3LTFQl4=";
  };

  patches = [
    (substituteAll {
      src = ./gvisor_run_py.patch;
      bash = bash;
      coreutils = coreutils;
      libfaketime = libfaketime;
      python3 = passthru.pythonEnv;
      gvisor = gvisor;
    })
  ];

  nativeBuildInputs = with nodePackages; [
    yarn
    nodejs
    prefetch-yarn-deps
    fixup-yarn-lock
    node-gyp-build
    node-pre-gyp
  ];

  propagatedBuildInputs = with python3.pkgs;
    [
      astroid
      asttokens
      chardet
      et-xmlfile
      executing
      friendly-traceback
      iso8601
      lazy-object-proxy
      openpyxl
      phonenumbers
      pure-eval
      python-dateutil
      roman
      six
      sortedcontainers
      stack-data
      typing-extensions
      unittest-xml-reporting
      wrapt
    ];

  passthru = {
    pythonEnv = python3.withPackages (_: propagatedBuildInputs);
    tests = {
      inherit (nixosTests) grist-core;
    };
  };

  postPatch = ''
    rm .yarnrc
  '';

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror ${offlineCache}
    fixup-yarn-lock yarn.lock

    mkdir -p "$HOME/.node-gyp/${nodejs.version}"
    echo 9 >"$HOME/.node-gyp/${nodejs.version}/installVersion"
    ln -sfv "${nodejs}/include" "$HOME/.node-gyp/${nodejs.version}"
    export npm_config_nodedir=${nodejs}

    yarn --offline --frozen-lockfile --ignore-platform --ignore-engines --no-progress --non-interactive install
    patchShebangs node_modules
    patchShebangs buildtools

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline run build:prod

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out

    cp -r _build $out
    cp -r node_modules $out
    cp -r plugins $out
    cp -r sandbox $out
    cp -r static $out
    cp -r bower_components $out

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/sandbox/run.sh \
      --replace-fail './sandbox/gvisor/get_checkpoint_path.sh' "$out/sandbox/gvisor/get_checkpoint_path.sh"
  '';

  meta = {
    description = "Grist is the evolution of spreadsheets";
    homepage = "https://github.com/gristlabs/grist-core";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    mainProgram = "grist-core";
    platforms = lib.platforms.all;
  };
}
