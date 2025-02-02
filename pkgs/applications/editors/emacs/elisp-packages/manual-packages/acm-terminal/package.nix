{
  lib,
  melpaBuild,
  fetchFromGitHub,
  acm,
  popon,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "acm-terminal";
  version = "0-unstable-2023-12-06";

  src = fetchFromGitHub {
    owner = "twlz0ne";
    repo = "acm-terminal";
    rev = "1851d8fa2a27d3fd8deeeb29cd21c3002b8351ba";
    hash = "sha256-EYhFrOo0j0JSNTdcZCbyM0iLxaymUXi1u6jZy8lTOaY=";
  };

  packageRequires = [
    acm
    popon
  ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://github.com/twlz0ne/acm-terminal";
    description = "Patch for LSP bridge acm on Terminal";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kira-bruneau ];
  };
}
