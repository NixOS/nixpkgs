{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  gitUpdater,
  libpcap,
}:

buildGo127Module (finalAttrs: {
  pname = "adalanche";
  version = "1014";

  src = fetchFromGitHub {
    owner = "lkarlslund";
    repo = "adalanche";
    tag = "r${finalAttrs.version}";
    hash = "sha256-y3+YEDZtTPl65vNjEKG69LacBxV3SFqr4xOko8doulk=";
  };

  vendorHash = "sha256-J9aZKGeiLeiNiYyWlzIZLmC3CjaeAXqSa4q+7PDJ7c4=";

  # The collectors are for Windows only.
  excludedPackages = [
    "collector"
    "localmachine/collect"
  ];

  buildInputs = [ libpcap ];

  ldflags = [
    "-s"
    "-X=github.com/lkarlslund/adalanche/modules/version.Version=${finalAttrs.version}"
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Active Directory ACL Visualizer and Explorer";
    homepage = "https://github.com/lkarlslund/adalanche";
    changelog = "https://github.com/lkarlslund/Adalanche/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "adalanche";
  };
})
