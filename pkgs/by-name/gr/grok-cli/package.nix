{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  makeBinaryWrapper,
}:

let
  pin = lib.importJSON ./pin.json;
  src = fetchFromGitHub {
    owner = "superagent-ai";
    repo = "grok-cli";
    tag = "@vibe-kit/grok-cli@${pin.version}";
    hash = pin.srcHash;
  };

  node_modules = stdenv.mkDerivation {
    pname = "grok-cli-node_modules";
    version = pin.version;
    inherit src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];
    nativeBuildInputs = [ bun ];
    dontConfigure = true;

    buildPhase = ''
      bun install --no-progress --frozen-lockfile
    '';

    installPhase = ''
      mkdir -p $out/node_modules

      cp -R ./node_modules $out
    '';

    outputHash = pin."${stdenv.system}";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "grok-cli";
  version = pin.version;
  inherit src;

  nativeBuildInputs = [
    bun
    makeBinaryWrapper
  ];

  dontConfigure = true;

  buildPhase = ''
    ln -s ${node_modules}/node_modules .
    bun run build
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    ln -s ${node_modules}/node_modules $out
    cp -R ./* $out

    makeBinaryWrapper ${bun}/bin/bun $out/bin/grok \
      --prefix PATH : ${lib.makeBinPath [ bun ]} \
      --add-flags "run --prefer-offline --no-install --cwd $out ./dist/index.js"

    runHook postInstall
  '';

  meta = with lib; {
    description = "An open-source AI agent that brings the power of Grok directly into your terminal.";
    homepage = "https://github.com/superagent-ai/grok-cli";
    mainProgram = "grok";
    maintainers = with maintainers; [ storopoli ];
    license = with licenses; [ mit ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
}
