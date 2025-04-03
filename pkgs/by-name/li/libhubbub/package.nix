{
  lib,
  stdenv,
  fetchurl,
  gperf,
  perl,
  pkg-config,
  netsurf-buildsystem,
  libparserutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libhubbub";
  version = "0.3.8";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libhubbub-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-isHm9fPUjAUUHVk5FxlTQpDFnNAp78JJ60/brBAs1aU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gperf
    perl
    netsurf-buildsystem
    libparserutils
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${netsurf-buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/hubbub/";
    description = "HTML5 parser library for netsurf browser";
    longDescription = ''
      Hubbub is an HTML5 compliant parsing library, written in C. It was
      developed as part of the NetSurf project and is available for use by other
      software under the MIT licence.

      The HTML5 specification defines a parsing algorithm, based on the
      behaviour of mainstream browsers, which provides instructions for how to
      parse all markup, both valid and invalid. As a result, Hubbub parses web
      content well.
    '';
    license = lib.licenses.mit;
    inherit (netsurf-buildsystem.meta) maintainers platforms;
  };
})
