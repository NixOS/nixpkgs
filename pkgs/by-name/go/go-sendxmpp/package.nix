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
  version = "0.15.5";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "mdosch";
    repo = "go-sendxmpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uOJ7pI+6ETjb0iRMM3XDeztXHjxNQlU05ODTiBi72LY=";
  };

  vendorHash = "sha256-tt70h/JG8t9tbhqJoPu0KPVJ8ZbNKq0h7oLfiPAL4jg=";

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
