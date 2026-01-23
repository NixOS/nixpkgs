{
  lib,
  stdenv,
  fetchurl,
  bison,
  flex,
  pkg-config,
  netsurf-buildsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnslog";
  version = "0.1.3";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libnslog-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-/JjcqdfvpnCWRwpdlsAjFG4lv97AjA23RmHHtNsEU9A=";
  };

  nativeBuildInputs = [
    bison
    flex
    pkg-config
  ];

  buildInputs = [ netsurf-buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${netsurf-buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "NetSurf Parametric Logging Library";
    license = lib.licenses.isc;
    inherit (netsurf-buildsystem.meta) maintainers platforms;
  };
})
