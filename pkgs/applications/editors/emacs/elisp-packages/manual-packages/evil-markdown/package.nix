{
  lib,
  evil,
  fetchFromGitHub,
  markdown-mode,
  melpaBuild,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "evil-markdown";
  version = "0-unstable-2021-07-21";

  src = fetchFromGitHub {
    owner = "Somelauw";
    repo = "evil-markdown";
    rev = "8e6cc68af83914b2fa9fd3a3b8472573dbcef477";
    hash = "sha256-HBBuZ1VWIn6kwK5CtGIvHM1+9eiNiKPH0GUsyvpUVN8=";
  };

  packageRequires = [
    evil
    markdown-mode
  ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://github.com/Somelauw/evil-markdown";
    description = "Integrates Emacs evil and markdown";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ leungbk ];
  };
}
