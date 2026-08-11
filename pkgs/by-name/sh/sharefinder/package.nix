{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "sharefinder";
  version = "1.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vflame6";
    repo = "sharefinder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-82hQPz05Xzvq5ggUht3GFaJ+3yEjES94mfZjQd5a+rA=";
  };

  vendorHash = "sha256-ABPq6WKYIjyCX5K8iU++6dszUW7s9Ld1Queb2hGdGzs=";

  ldflags = [
    "-s"
    "-X=github.com/vflame6/sharefinder/cmd.VERSION=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Active network shares enumeration tool";
    homepage = "https://github.com/vflame6/sharefinder";
    changelog = "https://github.com/vflame6/sharefinder/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sharefinder";
  };
})
