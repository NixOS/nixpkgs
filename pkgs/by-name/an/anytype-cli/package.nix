{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  tantivy-go,
}:
buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "anytype-cli";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "anytype-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9jJ4FV4ASUrhUvW/lI4qs7AmK06OkPfnD0+okl5blrs=";
  };

  vendorHash = "sha256-7J/nW4Jn2vdAs8sN+rV3wg6nV3JhtQrnLwlxNI0uja0=";
  proxyVendor = true;

  env.CGO_ENABLED = 1;
  env.CGO_LDFLAGS = "-L${tantivy-go}/lib";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/anyproto/anytype-cli/core.Version=v${finalAttrs.version}"
  ];

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
