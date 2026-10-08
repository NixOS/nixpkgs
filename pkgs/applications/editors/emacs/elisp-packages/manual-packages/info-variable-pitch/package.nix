{
  lib,
  melpaBuild,
  fetchFromGitHub,
  s,
  unstableGitUpdater,
}:
melpaBuild {
  pname = "info-variable-pitch";
  version = "0-unstable-2022-06-18";
  src = fetchFromGitHub {
    owner = "kisaragi-hiu";
    repo = "info-variable-pitch";
    rev = "e18e8dfb5dbea304fcf2312eb6cc8a0736e6eda0";
    hash = "sha256-/xp28m7RLRSXIveeTJnSElfu0XIXDmVvE3uJb8fpRJo=";
  };

  packageRequires = [ s ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/kisaragi-hiu/info-variable-pitch";
    description = "Like org-variable-pitch but for Info";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ johnhamelink ];
  };
}
