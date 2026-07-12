{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-tpc";
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = "go-tpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O+zHHSjucFh8T42P/IQAA993DmskJfoo1WdO8T95I88=";
  };

  vendorHash = "sha256-JInXHnHW5jfKism5OscYSJJjBBB7URYLSVpo4EJ/HAs=";

  ldflags = [
    "-s"
    "-w"
    "-X 'main.version=${finalAttrs.version}'"
  ];

  meta = {
    description = "Toolbox to benchmark TPC workloads in Go";
    homepage = "https://github.com/pingcap/go-tpc";
    license = lib.licenses.asl20;
    mainProgram = "go-tpc";
    maintainers = with lib.maintainers; [ lks ];
  };
})
