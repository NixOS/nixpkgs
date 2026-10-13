{
  buildGoModule,
  fetchFromGitLab,
  lib,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "go-sendxmpp";
  version = "0.17.0";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "mdosch";
    repo = "go-sendxmpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6/Eb0Ydhox1vqho9kI0Pc0D+ZPnARoFNK4b86OW//IY=";
  };

  vendorHash = "sha256-+0U7XXKVmeKWcaAMhbD96WLJkkupaOOIX4pyakZz1Z4=";

  passthru = {
    tests = { inherit (nixosTests) ejabberd prosody; };
    updateScript = nix-update-script { };
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

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
