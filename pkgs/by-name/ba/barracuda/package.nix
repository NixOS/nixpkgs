{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "barracuda";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Zaneham";
    repo = "Booth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WQGnW7fpTIJuUkf9OYWPPWbE4VMhfff32bKGR9e01oQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-but-set-variable";

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 barracuda -t $out/bin

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Multi architecture, multi language compiler with the intended goal of allowing for cross platform development on GPU's and CPU's";
    homepage = "https://github.com/Zaneham/Booth";
    changelog = "https://github.com/Zaneham/Booth/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ dstremur ];
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "barracuda";
  };
})
