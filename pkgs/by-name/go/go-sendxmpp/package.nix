{
  buildGoModule,
  fetchFromGitLab,
  lib,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "go-sendxmpp";
  version = "0.14.1";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "mdosch";
    repo = "go-sendxmpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nQ2URhkOp0mb4u4IG3wzGIdhP6svDVMctbu2CHQXj2Y=";
  };

  vendorHash = "sha256-aMhUsYsQvnhEVkWbjbh84bbStQ4b/0ZHEvzEhXSlFyw=";

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
