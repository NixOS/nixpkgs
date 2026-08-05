{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "badger";
  version = "4.9.5";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "badger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HDFL5lx14g2BTBZIzkr+tkKL7X+zbI64e0et710q14o=";
  };

  vendorHash = "sha256-NSjJDpLf6Ooi+6bwViAP5M7XNy95RLtVVcDAj0jkbyM=";

  subPackages = [ "badger" ];

  doCheck = false;

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/dgraph-io/badger/releases/tag/${finalAttrs.src.tag}";
    description = "Fast key-value DB in Go";
    homepage = "https://dgraph-io.github.io/badger";
    license = lib.licenses.asl20;
    mainProgram = "badger";
    maintainers = with lib.maintainers; [ hythera ];
  };
})
