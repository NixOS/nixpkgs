{
  lib,
  unstableGitUpdater,
  melpaBuild,
  fetchFromGitHub,
  magit,
}:
melpaBuild {
  pname = "magit-standup";
  version = "0-unstable-2026-02-16";
  src = fetchFromGitHub {
    owner = "function-artisans";
    repo = "magit-standup";
    rev = "876b1a592e131eede23de45784ea769fb16e18af";
    hash = "sha256-ALvkO3nOkg+n53FSzcSG36BGsOThg5rBQAVegdw2f88=";
  };

  packageRequires = [ magit ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/function-artisans/magit-standup";
    description = "Collect recent git commits for standup notes";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ johnhamelink ];
  };
}
