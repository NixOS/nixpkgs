{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "badger";
  version = "4.9.6";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "badger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LAW6WCtyzMFlycbTkdqt7FVbamkCpi0E/qgfNq4o8iM=";
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
