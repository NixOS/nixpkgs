{
  stdenv,
  lib,
  fetchFromGitHub,
  bun,
  makeBinaryWrapper,
}:
let
  pin = lib.importJSON ./pin.json;
  src = fetchFromGitHub {
    owner = "leona";
    repo = "helix-gpt";
    rev = pin.version;
    hash = pin.srcHash;
  };
  node_modules = stdenv.mkDerivation {
    pname = "helix-gpt-node_modules";
    inherit src;
    version = pin.version;
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
  pname = "helix-gpt";
  version = pin.version;
  inherit src;
  nativeBuildInputs = [ makeBinaryWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    ln -s ${node_modules}/node_modules $out
    cp -R ./* $out

    # bun is referenced naked in the package.json generated script
    makeBinaryWrapper ${bun}/bin/bun $out/bin/helix-gpt \
      --prefix PATH : ${lib.makeBinPath [ bun ]} \
      --add-flags "run --prefer-offline --no-install --cwd $out ./src/app.ts"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/leona/helix-gpt";
    changelog = "https://github.com/leona/helix-gpt/releases/tag/${src.rev}";
    description = "Code completion LSP for Helix with support for Copilot + OpenAI";
    mainProgram = "helix-gpt";
    maintainers = with maintainers; [ happysalada ];
    license = with licenses; [ mit ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
}
