{ lib
, melpaBuild
, fetchFromGitHub
, acm
, popon
, writeText
, unstableGitUpdater
}:

let
<<<<<<< HEAD
  rev = "0dbbd7f401da1bedd1a9146df6127233d601435b";
in
melpaBuild {
  pname = "acm-terminal";
  version = "20230601.1326"; # 13:26 UTC
=======
  rev = "321e05fc0398a6159925b858f46608ea07ef269e";
in
melpaBuild {
  pname = "acm-terminal";
  version = "20230215.414"; # 4:14 UTC
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "twlz0ne";
    repo = "acm-terminal";
    inherit rev;
<<<<<<< HEAD
    sha256 = "sha256-Opouy9A6z0YUT1zxZq1yHx+r/hwNE93JDwfa1fMWNgc=";
=======
    sha256 = "sha256-Flw07EwH9z0E3tqXs4mStICJmoHfp60ALrP1GmUmeuU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
