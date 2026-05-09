{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "adalanche";
  version = "2025.2.6";

  src = fetchFromGitHub {
    owner = "lkarlslund";
    repo = "adalanche";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PEq0bIZTtaUoNUTPypq9OAzhwC2SM1KKtjfS9QZwo6c=";
  };

  vendorHash = "sha256-TTJ82l+oMGixQnpW0JxBndPuAuKe6TAjJnN0a1LPtSY=";

  buildInputs = [
    libpcap
  ];

  # sonic dependency uses internal go APIs blocked in Go 1.23+
  # See https://github.com/bytedance/sonic/issues/711
  ldflags = [
    "-s"
    "-w"
    "-X=github.com/lkarlslund/adalanche/modules/version.Version=${finalAttrs.version}"
    "-checklinkname=0"
  ];

  checkFlags = [
    "-skip=TestParseTestAQLQueries|TestParsePredefinedAQLQueries"
  ];

  meta = {
    description = "Active Directory ACL Visualizer and Explorer";
    homepage = "https://github.com/lkarlslund/adalanche";
    changelog = "https://github.com/lkarlslund/Adalanche/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "adalanche";
  };
})
