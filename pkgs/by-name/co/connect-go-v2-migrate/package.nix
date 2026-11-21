{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "connect-go-v2-migrate";
  version = "2.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LN28z4jxLem0w0qavQ62kZuPELBqr+0pMKsdR5aS+Hs=";
  };
  modRoot = "cmd/connect-go-v2-migrate";

  vendorHash = "sha256-pESK+Z6JrlSWjgPtkBnW6sAspvPhPj3HRzPERGT++EE=";

  # tests require networking to grab remote go dependencies
  doCheck = false;

  meta = {
    description = "Migration tool for Connect V2";
    mainProgram = "connect-go-v2-migrate";
    homepage = "https://github.com/connectrpc/connect-go/blob/${finalAttrs.src.tag}/docs/v2-migration.md";
    changelog = "https://github.com/connectrpc/connect-go/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kilimnik
      jk
    ];
  };
})
