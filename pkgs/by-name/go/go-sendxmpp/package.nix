{
  buildGoModule,
  fetchFromGitLab,
  lib,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "go-sendxmpp";
  version = "0.15.1";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "mdosch";
    repo = "go-sendxmpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dXSja3k7Gb9fzP3TrQqB9KRVO90i967eVaLldwhBnvQ=";
  };

  vendorHash = "sha256-fnaOgc8RPDQnxTWOLQx1kw0+qj1iaff+UkjnoJYdEG4=";

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
