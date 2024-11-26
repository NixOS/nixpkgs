{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "sus-compiler";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "pc2";
    repo = "sus-compiler";
    rev = "v${version}";
    hash = "sha256-VSoroUultjBn2KxfvyhS923RQ/1v9AXb15k4/MoR+oM=";
    fetchSubmodules = true;
  };

  # no lockfile upstream
  cargoLock.lockFile = ./Cargo.lock;

  preBuild = ''
    export HOME="$TMPDIR";
  '';

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/sus_compiler";

  meta = {
    description = "A new Hardware Design Language that keeps you in the driver's seat";
    homepage = "https://github.com/pc2/sus-compiler";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "sus_compiler";
  };
}
