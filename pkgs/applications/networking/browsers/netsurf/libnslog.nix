{ lib
, stdenv
, fetchurl
, bison
, flex
, pkg-config
, buildsystem
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libnslog";
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

  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "NetSurf Parametric Logging Library";
    license = lib.licenses.isc;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
