{ racket }:

racket.makePackage {
  name = "resource-pool-lib";
  version = "0.1";
  source = {
    method = "github";
    path = "resource-pool-lib";
    args = {
      owner = "Bogdanp";
      repo = "racket-resource-pool";
      hash = "sha256-X3JOS9ZqsVmeuO1psquwM56BzcL5BIw6IiPicDYUV1w=";
    };
  };
  checksum = "019ee1c17e5596d2e2e8cd1387811440da2dc95a";
}
