{
  breakpointHook,
  curl,
  dotnet-sdk,
  fetchFromGitHub,
  lib,
  openra,
  python3,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "open-sa";
  version = "20230905";

  src = fetchFromGitHub {
    owner = "Dzierzan";
    repo = "OpenSA";
    rev = finalAttrs.version;
    hash = "sha256-dLy8cUowUwsuxLMMnV/C0SlzqGsX1f4mpXYLykCF6xE=";
  };

  configurePhase = ''
    echo "AUTOMATIC_ENGINE_MANAGEMENT=False" > user.config
    echo "ENGINE_VERSION={DEV_VERSION}" >> user.config
    echo "ENGINE_DIRECTORY=${openra.src}" >> user.config
  '';

  buildInputs = [ openra.nugetDeps ];

  nativeBuildInputs = [
    dotnet-sdk
    curl
    breakpointHook
    python3
  ];

  meta = {
    description = "This repository contains Swarm Assault remake project based on the OpenRA Mod SDK";
    homepage = "https://github.com/Dzierzan/OpenSA";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "open-sa";
  };
})
