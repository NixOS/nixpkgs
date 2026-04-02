{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-mod-graph-chart";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "PaulXu-cn";
    repo = "go-mod-graph-chart";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vitUZXQyAj72ed9Gukr/sAT/iWWMhwsxjZhf2a9CM7I=";
  };

  vendorHash = null;

  # check requires opening webpage
  doCheck = false;

  meta = {
    description = "Tool build chart by go mod graph output with zero dependencies";
    homepage = "https://github.com/PaulXu-cn/go-mod-graph-chart";
    mainProgram = "gmchart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
  };
})
