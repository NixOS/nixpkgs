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
})
