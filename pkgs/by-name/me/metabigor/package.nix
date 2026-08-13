{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "metabigor";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "j3ssie";
    repo = "metabigor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zlgPlCNNE6y4L4+Urw/EbNMwzSnOajILDHaT7HPVRqM=";
  };

  vendorHash = "sha256-hqFu2sUh2M0vO7/Zm46IW0Zlbx9Q8uwEnD8WXL8SC14=";

  ldflags = [ "-s" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  # Disabled for now as there are some failures ("undefined:")
  doCheck = false;

  doInstallCheck = true;

  meta = {
    description = "Tool to perform OSINT tasks";
    homepage = "https://github.com/j3ssie/metabigor";
    changelog = "https://github.com/j3ssie/metabigor/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "metabigor";
  };
})
