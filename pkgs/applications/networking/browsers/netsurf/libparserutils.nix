{ lib
, stdenv
, fetchurl
, perl
, buildsystem
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libparserutils";
  version = "0.2.4";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libparserutils-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-MiuuYbMMzt4+MFv26uJBSSBkl3W8X/HRtogBKjxJR9g=";
  };

  buildInputs = [
    perl
    buildsystem
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libparserutils/";
    description = "Parser building library for netsurf browser";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
