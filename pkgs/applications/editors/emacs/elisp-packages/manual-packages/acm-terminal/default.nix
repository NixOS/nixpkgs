{ lib
, melpaBuild
, fetchFromGitHub
, acm
, popon
, writeText
, unstableGitUpdater
}:

let
  rev = "0dbbd7f401da1bedd1a9146df6127233d601435b";
in
melpaBuild {
  pname = "acm-terminal";
  version = "20230601.1326"; # 13:26 UTC

  src = fetchFromGitHub {
    owner = "twlz0ne";
    repo = "acm-terminal";
    inherit rev;
    sha256 = "sha256-Opouy9A6z0YUT1zxZq1yHx+r/hwNE93JDwfa1fMWNgc=";
  };

  commit = rev;

  packageRequires = [
    acm
    popon
  ];

  recipe = writeText "recipe" ''
    (acm-terminal :repo "twlz0ne/acm-terminal" :fetcher github)
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Patch for LSP bridge acm on Terminal";
    homepage = "https://github.com/twlz0ne/acm-terminal";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
