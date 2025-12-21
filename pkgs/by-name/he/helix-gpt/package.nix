{
  stdenv,
  lib,
  fetchFromGitHub,
  bun,
  makeBinaryWrapper,
}:
stdenv.mkDerivation rec {
  pname = "helix-gpt";
  version = "0.34";
  src = fetchFromGitHub {
    owner = "leona";
    repo = "helix-gpt";
    rev = version;
    hash = "sha256-F2E+B4kKLpX4g/iCv0i71hSx4xdV6fdkwksslELdZUQ=";
  };
  nativeBuildInputs = [
    makeBinaryWrapper
    bun.configHook
  ];

  bunDeps = bun.fetchDeps {
    inherit src version pname;
    hash = "sha256-rnbQDZdql418bDJZ3le4KGedtywE2M1ZIv0ZFnLObZU=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

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
