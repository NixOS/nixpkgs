{ pcre, pcre2, picom, lib, fetchFromGitHub }:

picom.overrideAttrs (oldAttrs: rec {
  pname = "picom-next";
  version = "unstable-2022-12-23";
  buildInputs = [ pcre2 ] ++ lib.remove pcre oldAttrs.buildInputs;
  src = fetchFromGitHub {
    owner = "yshui";
    repo = "picom";
    rev = "60ac2b64db78363fe04189cc734daea3d721d87e";
    sha256 = "09s8kgczks01xbvg3qxqi2rz3lkzgdfyvhrj30mg6n11b6xfgi0d";
  };
  meta.maintainers = with lib.maintainers; oldAttrs.meta.maintainers ++ [ GKasparov ];
})
