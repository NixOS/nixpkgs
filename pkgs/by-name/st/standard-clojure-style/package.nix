{
  stdenv,
  lib,
  fetchFromGitHub,
  bash,
  bun,
  makeBinaryWrapper,
  nodejs,
}:
let
  pin = lib.importJSON ./pin.json;
  src = fetchFromGitHub {
    owner = "oakmac";
    repo = "standard-clojure-style-js";
    tag = "v${pin.version}";
    hash = pin.srcHash;
  };
  node_modules = stdenv.mkDerivation {
    pname = "standard-clojure-style-node_modules";
    inherit src;
    version = pin.version;
    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];
    nativeBuildInputs = [ bun ];
    dontConfigure = true;
    dontPatchShebangs = true;
    buildPhase = ''
      bun install --no-progress --frozen-lockfile
      rm -rf node_modules/.cache
    '';
    installPhase = ''
      mkdir -p $out/node_modules

      cp -R ./node_modules $out
    '';
    outputHash = pin.outputHash;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "standard-clojure-style";
  version = pin.version;
  inherit src;
  nativeBuildInputs = [
    bash
    makeBinaryWrapper
    nodejs
  ];
  strictDeps = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    ln -s ${node_modules}/node_modules $out
    cp -R ./* $out

    cd $out
    node ./scripts/build-release.js

    # bun is referenced naked in the package.json generated script
    makeBinaryWrapper ${bun}/bin/bun $out/bin/standard-clj \
      --prefix PATH : ${lib.makeBinPath [ bun ]} \
      --add-flags "run --prefer-offline --no-install $out/cli.mjs"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/oakmac/standard-clojure-style-js";
    changelog = "https://github.com/oakmac/standard-clojure-style-js/releases/tag/v${pin.version}";
    description = "Format Clojure code according to Standard Clojure Style";
    mainProgram = "standard-clj";
    maintainers = with lib.maintainers; [ john-shaffer ];
    license = with lib.licenses; [ isc ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
}
