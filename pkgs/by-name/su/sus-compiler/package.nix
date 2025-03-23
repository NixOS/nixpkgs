{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sus-compiler";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "pc2";
    repo = "sus-compiler";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0OZPBdilNknGCjWzXjyUAW57cpyyyV80EEo6pDlpG3g=";
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

  updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    description = "A new Hardware Design Language that keeps you in the driver's seat";
    homepage = "https://github.com/pc2/sus-compiler";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "sus_compiler";
  };
})
