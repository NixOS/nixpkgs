{ lib
, stdenv
, fetchurl
, perl
, pkg-config
, buildsystem
, libparserutils
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libhubbub";
  version = "0.3.7";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libhubbub-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-nnriU+bJBp51frmtTkhG84tNtSwMoBUURqn6Spd3NbY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    perl
    buildsystem
    libparserutils
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
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
    inherit (buildsystem.meta) maintainers platforms;
  };
})
