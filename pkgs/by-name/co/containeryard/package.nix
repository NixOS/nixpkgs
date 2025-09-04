{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "containeryard";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "mcmah309";
    repo = "containeryard";
    tag = "v${version}";
    hash = "sha256-L73HTmfdcGKD+TKRt34Ai8SUwCEuuMEo4k0lC9g7K+U=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';
  
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/yard";
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;


  meta = with lib; {
    description = "ContainerYard is a declarative, reproducible, and reusable decentralized approach for defining containers. Think Nix flakes meets Containerfiles (aka Dockerfiles).";
    homepage = "https://github.com/mcmah309/containeryard";
    changelog = "https://github.com/mcmah309/containeryard/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mcmah309 ];
    mainProgram = "yard";
  };
}
