{ lib
, trivialBuild
, fetchFromGitHub
, emacs
, evil
, markdown-mode
}:

trivialBuild rec {
  pname = "evil-markdown";
  version = "0.pre+unstable=2021-07-21";

  src = fetchFromGitHub {
    owner = "Somelauw";
    repo = "evil-markdown";
    rev = "8e6cc68af83914b2fa9fd3a3b8472573dbcef477";
    hash = "sha256-HBBuZ1VWIn6kwK5CtGIvHM1+9eiNiKPH0GUsyvpUVN8=";
  };

  buildInputs = propagatedUserEnvPkgs;

  propagatedUserEnvPkgs = [
    evil
    markdown-mode
  ];

  meta = with lib; {
    homepage = "https://github.com/Somelauw/evil-markdown";
    description = "Integrates Emacs evil and markdown";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ leungbk ];
    inherit (emacs.meta) platforms;
  };
}
