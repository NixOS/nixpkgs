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
})
