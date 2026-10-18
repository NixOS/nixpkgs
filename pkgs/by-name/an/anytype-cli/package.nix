{
  lib,
  buildGoModule,
  fetchFromGitHub,
  tantivy-go,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "anytype-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "anytype-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xLR2drI0THlwknb6AWgZj81zGmGQrtaVYPxEtsJ3SIA=";
  };

  vendorHash = "sha256-4MkXsSCa4c6aXLJ/tZ5w0tE3BnGkTak4lprrozs61oI=";
  proxyVendor = true;

  env.CGO_ENABLED = 1;
  env.CGO_LDFLAGS = "-L${tantivy-go}/lib";

  ldflags = [
    "-s"
    "-X github.com/anyproto/anytype-cli/core.Version=v${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line interface for interacting with Anytype";
    homepage = "https://github.com/anyproto/anytype-cli";
    changelog = "https://github.com/anyproto/anytype-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "anytype-cli";
    maintainers = with lib.maintainers; [
      adda
      wanderer
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
