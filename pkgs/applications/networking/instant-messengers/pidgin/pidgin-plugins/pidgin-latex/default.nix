{ lib, stdenv, fetchurl, pkg-config, pidgin, texLive, imagemagick, glib, gtk2 }:

let version = "1.5.0";
in
stdenv.mkDerivation {
  pname = "pidgin-latex";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/pidgin-latex/pidgin-latex_${version}.tar.bz2";
    sha256 = "9c850aee90d7e59de834f83e09fa6e3e51b123f06e265ead70957608ada95441";
  };

  nativeBuildInputs = [pkg-config];
  buildInputs = [gtk2 glib pidgin];
  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    sed -e 's/-Wl,-soname//' -i Makefile
  '';

  passthru = {
    wrapArgs = "--prefix PATH ':' ${lib.makeBinPath [ texLive imagemagick ]}";
  };

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/pidgin-latex/";
    description = "LaTeX rendering plugin for Pidgin IM";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
