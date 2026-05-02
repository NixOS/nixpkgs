{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "scip-go";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-c2yCe1dtTVA6rWhphN7LGUY0lz9Xn/AVTSAB6uRMHs0=";
  };

  vendorHash = "sha256-TPd0CvNoAlskbGtKi7exxy+u9HabFJdprJ595ybRRQ8=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = {
    description = "SCIP (SCIP Code Intelligence Protocol) indexer for Golang";
    homepage = "https://github.com/sourcegraph/scip-go/tree/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arikgrahl ];
    mainProgram = "scip-go";
  };
})
