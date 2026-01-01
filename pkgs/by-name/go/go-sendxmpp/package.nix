{
  buildGoModule,
  fetchFromGitLab,
  lib,
<<<<<<< HEAD
  nixosTests,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "go-sendxmpp";
<<<<<<< HEAD
  version = "0.15.4";
=======
  version = "0.15.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "mdosch";
    repo = "go-sendxmpp";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-gZbUSzUfVWJ0cTwKOuPEsynhj0dAXHrpILjpR2NZNWE=";
  };

  vendorHash = "sha256-GNIfmh6GZYh3vOLrjsgSW0ZWanXZkzBiq0H72RxdOJI=";

  passthru = {
    tests = { inherit (nixosTests) ejabberd prosody; };
=======
    hash = "sha256-dXSja3k7Gb9fzP3TrQqB9KRVO90i967eVaLldwhBnvQ=";
  };

  vendorHash = "sha256-fnaOgc8RPDQnxTWOLQx1kw0+qj1iaff+UkjnoJYdEG4=";

  passthru = {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    updateScript = nix-update-script { };
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Tool to send messages or files to an XMPP contact or MUC";
    homepage = "https://salsa.debian.org/mdosch/go-sendxmpp";
    changelog = "https://salsa.debian.org/mdosch/go-sendxmpp/-/releases/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      jpds
    ];
    mainProgram = "go-sendxmpp";
  };
})
