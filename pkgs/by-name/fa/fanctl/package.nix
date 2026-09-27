{
  lib,
  fetchFromGitLab,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  version = "0.6.4";
  pname = "fanctl";

  src = fetchFromGitLab {
    owner = "mcoffin";
    repo = "fanctl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XmawybmqRJ9Lj6ii8TZBFwqdQZVp0pOLN4xiSLkU/bw=";
  };

  cargoHash = "sha256-CfONnF5gUnfPVmLSNzsk6xYEv70CnJfI3Gi9vCkrAcE=";

  meta = {
    description = "Replacement for fancontrol with more fine-grained control interface in its config file";
    mainProgram = "fanctl";
    homepage = "https://gitlab.com/mcoffin/fanctl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ icewind1991 ];
    platforms = lib.platforms.linux;
  };
})
