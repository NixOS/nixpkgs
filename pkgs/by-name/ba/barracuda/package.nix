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
    repo = "BarraCUDA";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WQGnW7fpTIJuUkf9OYWPPWbE4VMhfff32bKGR9e01oQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

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
    homepage = "https://github.com/Zaneham/BarraCUDA";
    changelog = "https://github.com/Zaneham/BarraCUDA/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ dstremur ];
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "barracuda";
  };
})
