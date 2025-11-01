{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  bash,
  bun,
  makeBinaryWrapper,
  nodejs,
}:
let
  pname = "standard-clojure-style";
  version = "0.25.0";
  src = fetchFromGitHub {
    owner = "oakmac";
    repo = "standard-clojure-style-js";
    tag = "v${version}";
    hash = "sha256-wZ/5rJYngnAE1NVLGxQ4GS15dCjvuQBnBNxTCm3lyJM=";
  };
  node_modules = stdenv.mkDerivation {
    pname = "${pname}-node_modules";
    inherit src version;
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
    outputHash = "sha256-1XeVpiaS6kInT7fpJC8u+qqXKiocH6jZnIDanoibWIY=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  inherit pname src version;
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

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/oakmac/standard-clojure-style-js";
    changelog = "https://github.com/oakmac/standard-clojure-style-js/releases/tag/v${version}";
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
