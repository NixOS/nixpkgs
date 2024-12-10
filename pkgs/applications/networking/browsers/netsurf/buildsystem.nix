{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-buildsystem";
  version = "1.10";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/buildsystem-${finalAttrs.version}.tar.gz";
    hash = "sha256-PT451WnkRnfEsXkSm95hTGV5jis+YlMWAjnR/W6uTXk=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "NetSurf browser shared build system";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      vrthra
      AndersonTorres
    ];
    platforms = lib.platforms.unix;
  };
})
