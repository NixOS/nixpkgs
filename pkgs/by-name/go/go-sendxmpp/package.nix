{
  buildGoModule,
  fetchFromGitLab,
  lib,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "go-sendxmpp";
  version = "0.15.0";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "mdosch";
    repo = "go-sendxmpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S4KoCMlW+uUJcQTYkEtlRT4IAALfRFSj2UDZk4A5e5g=";
  };

  vendorHash = "sha256-Qe95u+M9X45cVO9MNLPxoyMyoWOAYYQ2n/GorD/PMIA=";

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to send messages or files to an XMPP contact or MUC";
    homepage = "https://salsa.debian.org/mdosch/go-sendxmpp";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      jpds
    ];
    mainProgram = "go-sendxmpp";
  };
})
