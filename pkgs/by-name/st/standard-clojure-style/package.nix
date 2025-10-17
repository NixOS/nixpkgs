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
      bun install --frozen-lockfile --no-progress --no-save
      rm -rf node_modules/.bin node_modules/.cache
    '';
    installPhase = ''
      mkdir -p $out/node_modules

      cp -R ./node_modules $out
    '';
    outputHash =
      {
        aarch64-darwin = "sha256-eE5ozYjXwEATM6gMlGfd7b0QdXcf9ocwRYrVZrVx83k=";
        aarch64-linux = "sha256-2rhfJrpz3yzV79KpLeGzxphsc9zd0CJQ+xLqMaKW01Q=";
        x86_64-darwin = "sha256-eE5ozYjXwEATM6gMlGfd7b0QdXcf9ocwRYrVZrVx83k=";
        x86_64-linux = "sha256-2rhfJrpz3yzV79KpLeGzxphsc9zd0CJQ+xLqMaKW01Q=";
      }
      .${stdenv.hostPlatform.system};
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
    cp -R ./lib ./scripts ./cli.mjs ./package.json $out

    cd $out
    node ./scripts/build-release.js

    # bun is referenced naked in the package.json generated script
    makeBinaryWrapper ${bun}/bin/bun $out/bin/standard-clj \
      --prefix PATH : ${lib.makeBinPath [ bun ]} \
      --add-flags "run --prefer-offline --no-install $out/cli.mjs"

    rm -rf scripts package.json

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/oakmac/standard-clojure-style-js";
    changelog = "https://github.com/oakmac/standard-clojure-style-js/releases/tag/v${version}";
    description = "Format Clojure code according to Standard Clojure Style";
    mainProgram = "standard-clj";
    maintainers = with lib.maintainers; [ john-shaffer ];
    license = [ lib.licenses.isc ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
}
