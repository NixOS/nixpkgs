{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  glib,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  pname = "libgmpris";
  version = "2.2.1-8";

  src = fetchurl {
    url = "https://www.sonarnerd.net/src/focal/src/${pname}_${version}.tar.gz";
    sha256 = "sha256-iyKNmg6sf+mxlY/4vt5lKdrKfJzkoCYU2j1O8uwk8K4=";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];

  buildInputs = [ glib ];

  postInstall = ''
    mkdir -p $out/share/doc/${pname}
    cp ./AUTHORS $out/share/doc/${pname}
    cp ./README $out/share/doc/${pname}
  '';

  meta = with lib; {
    homepage = "https://www.sonarnerd.net/src/";
    description = "GMPRIS GDBus bindings GDBus bindings generated from the GMPRIS XML spec files";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
