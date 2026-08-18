{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "melt";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "melt";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-rZJSjWmcVPri/BmGrm+fDi2WgtPReQ9lesmBhMsdddo=";
  };

  vendorHash = "sha256-ZCHPbLjf2rTlg+Nj3v+XRW2xDN0qqhnlrF4sXNrGH/E=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Backup and restore Ed25519 SSH keys with seed words";
    mainProgram = "melt";
    homepage = "https://github.com/charmbracelet/melt";
    changelog = "https://github.com/charmbracelet/melt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
