{ stdenv, gcc7, pkg-config
, next
, webkitgtk, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "next-gtk-webkit";
  inherit (next) src version;

  makeFlags = [ "gtk-webkit" "PREFIX=$(out)" ];
  installTargets = "install-gtk-webkit";

  nativeBuildInputs = [ gcc7 pkg-config ];
  buildInputs = [
    webkitgtk
    gsettings-desktop-schemas
  ];
  meta = with stdenv.lib; {
    description = "Infinitely extensible web-browser (user interface only)";
    homepage = https://next.atlas.engineer;
    license = licenses.bsd3;
    maintainers = [ maintainers.lewo ];
    platforms = [ "x86_64-linux" ];
  };
}
