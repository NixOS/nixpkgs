{ lib
, melpaBuild
, fetchFromGitHub
, acm
, popon
, writeText
, unstableGitUpdater
}:

let
  rev = "321e05fc0398a6159925b858f46608ea07ef269e";
in
melpaBuild {
  pname = "acm-terminal";
  version = "20230215.414"; # 4:14 UTC

  src = fetchFromGitHub {
    owner = "twlz0ne";
    repo = "acm-terminal";
    inherit rev;
    sha256 = "sha256-Flw07EwH9z0E3tqXs4mStICJmoHfp60ALrP1GmUmeuU=";
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
