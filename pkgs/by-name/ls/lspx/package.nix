{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  deno,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lspx";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "thefrontside";
    repo = "lspx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NEwcNE5RxN/rl75bRxUQgANtqp26Y88HV/WKMtytt8k=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir --parent $out/lib
    cp --recursive * $out/lib

    runHook postInstall
  '';

  postInstall = ''
    makeWrapper ${lib.getExe' deno "deno"} $out/bin/${finalAttrs.meta.mainProgram} \
      --add-flags "run --allow-all $out/lib/main.ts" \
      --set DENO_NO_UPDATE_CHECK "1"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server multiplexer, supervisor, and interactive shell";
    homepage = "https://github.com/thefrontside/lspx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "lspx";
    inherit (deno.meta) platforms;
  };
})
