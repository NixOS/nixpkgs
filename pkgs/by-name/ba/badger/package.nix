{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "badger";
  version = "4.9.4";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "badger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v/E53imP3wxf7n1nlA0izjdSDkq1mwx7//BcLDPugY4=";
  };

  vendorHash = "sha256-KDIwEH83nPMJPJGTN3UgO00pjYwR17XqGdPXioP1YcY=";

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
