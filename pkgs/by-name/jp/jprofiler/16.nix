{
  callPackage,
  jdk25,
}:

callPackage ./common.nix {
  version = "16.3";
  jdk = jdk25;
  icon = "i4j_extf_12_11o2e4f_wkw4tw.png";
  hashes = {
    linux = "sha256-ws6SFiEVXRwe+LI72uIqOIlYImd33qCRSwuiidXGLuA=";
    darwin = "sha256-FEfobsgHgdYSytrFm5iXUC0ErvFOvhVwAkL0+ndq3Yo=";
  };
}
