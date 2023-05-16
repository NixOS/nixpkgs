<<<<<<< HEAD
{ lib
, fetchFromGitHub
, libXinerama
, pcre
, pcre2
, picom
, xcbutil
}:

picom.overrideAttrs (oldAttrs: {
  pname = "picom-next";
  version = "unstable-2023-08-03";

  buildInputs = [
    pcre2
    xcbutil
  ]
  # remove dependencies that are not used anymore
  ++ (lib.subtractLists [
    libXinerama
    pcre
  ]
    oldAttrs.buildInputs);

  src = fetchFromGitHub {
    owner = "yshui";
    repo = "picom";
    rev = "5d6957d3da1bf99311a676eab94c69ef4276bedf";
    hash = "sha256-Mzf0533roLSODjMCPKyGSMbP7lIbT+PoLTZfoIBAI6g=";
  };

  meta = oldAttrs.meta // {
    maintainers = with lib.maintainers; oldAttrs.meta.maintainers ++ [ GKasparov ];
  };
=======
{ pcre, pcre2, libXinerama, picom, lib, fetchFromGitHub }:

picom.overrideAttrs (oldAttrs: rec {
  pname = "picom-next";
  version = "unstable-2023-01-29";
  buildInputs = [ pcre2 ] ++ lib.remove libXinerama (lib.remove pcre oldAttrs.buildInputs);
  src = fetchFromGitHub {
    owner = "yshui";
    repo = "picom";
    rev = "cee12875625465292bc11bf09dc8ab117cae75f4";
    sha256 = "sha256-lVwBwOvzn4ro1jInRuNvn1vQuwUHUp4MYrDaFRmW9pc=";
  };
  meta.maintainers = with lib.maintainers; oldAttrs.meta.maintainers ++ [ GKasparov ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
})
