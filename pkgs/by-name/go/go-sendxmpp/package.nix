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
  version = "0.15.6";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "mdosch";
    repo = "go-sendxmpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HoK13rhsH5OyRHLuuCC+zGpcrK1591Zqy0hUinHbhcE=";
  };

  vendorHash = "sha256-Zy3oewVeoKEIOmh2lxyjBIHNCJX/YtWxuGOk6IM9CXs=";

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
