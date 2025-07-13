{
  lib,
  stdenv,
  fetchurl,
  perl,
  librsvg,
}:

stdenv.mkDerivation rec {
  pname = "icon-naming-utils";
  version = "0.8.90";

  src = fetchurl {
    url = "https://tango.freedesktop.org/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  buildInputs = [
    librsvg
    (perl.withPackages (p: [ p.XMLSimple ]))
  ];

  meta = with lib; {
    homepage = "https://tango.freedesktop.org/Standard_Icon_Naming_Specification";
    platforms = with platforms; linux ++ darwin;
    license = licenses.gpl2;
  };
}
