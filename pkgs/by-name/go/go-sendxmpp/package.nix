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
  version = "0.17.1";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "mdosch";
    repo = "go-sendxmpp";
    tag = "v${finalAttrs.version}+build2";
    hash = "sha256-MDZvZsJGdz7yJIp6Dn5hpfe5cjY+wX1OegrUo7CPXJw=";
  };

  vendorHash = "sha256-6LD3C9kh/MpqfV2ti9yLB6hGrYkYX+piqxFzmWzLwL0=";

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
