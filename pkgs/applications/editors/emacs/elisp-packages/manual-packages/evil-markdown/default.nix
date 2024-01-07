{ lib
, evil
, fetchFromGitHub
, markdown-mode
, melpaBuild
, writeText
}:

let
  pname = "evil-markdown";
  ename = "evil-markdown";
  version = "20210721.723";
  src = fetchFromGitHub {
    owner = "Somelauw";
    repo = "evil-markdown";
    rev = "8e6cc68af83914b2fa9fd3a3b8472573dbcef477";
    hash = "sha256-HBBuZ1VWIn6kwK5CtGIvHM1+9eiNiKPH0GUsyvpUVN8=";
  };
in
melpaBuild {
  inherit pname ename version src;

  packageRequires = [
    evil
    markdown-mode
  ];

  commit = src.rev;

  recipe = writeText "recipe" ''
    (evil-markdown
     :repo "Somelauw/evil-markdown"
     :fetcher github)
  '';

  meta = {
    homepage = "https://github.com/Somelauw/evil-markdown";
    description = "Integrates Emacs evil and markdown";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ leungbk ];
  };
}
