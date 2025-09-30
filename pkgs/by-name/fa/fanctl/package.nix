{
  lib,
  fetchFromGitLab,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  version = "0.6.4";
  pname = "fanctl";

  src = fetchFromGitLab {
    owner = "mcoffin";
    repo = "fanctl";
    rev = "v${version}";
    hash = "sha256-XmawybmqRJ9Lj6ii8TZBFwqdQZVp0pOLN4xiSLkU/bw=";
  };

  cargoHash = "sha256-CfONnF5gUnfPVmLSNzsk6xYEv70CnJfI3Gi9vCkrAcE=";

  meta = with lib; {
    description = "Replacement for fancontrol with more fine-grained control interface in its config file";
    mainProgram = "fanctl";
    homepage = "https://gitlab.com/mcoffin/fanctl";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ icewind1991 ];
    platforms = platforms.linux;
  };
}
