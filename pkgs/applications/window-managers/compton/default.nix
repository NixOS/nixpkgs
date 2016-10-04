{ stdenv, fetchurl, pkgconfig, dbus, libconfig, libdrm, libxml2, mesa, pcre,
  libXcomposite, libXfixes, libXdamage, libXinerama, libXrandr, libXrender,
  libXext, xwininfo }:

stdenv.mkDerivation rec {
  name = "compton-0.1_beta2";

  src = fetchurl {
    url = https://github.com/chjj/compton/releases/download/v0.1_beta2/compton-git-v0.1_beta2-2013-10-21.tar.xz;
    sha256 = "1mpgn1d98dv66xs2j8gaxjiw26nzwl9a641lrday7h40g3k45g9v";
  };

  buildInputs = [
    pkgconfig
    dbus
    libconfig
    libdrm
    libxml2
    mesa
    pcre
    libXcomposite
    libXfixes
    libXdamage
    libXinerama
    libXrandr
    libXrender
    libXext
  ];
  
  propagatedBuildInputs = [ xwininfo ];
  
  installFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    homepage = https://github.com/chjj/compton/;
    description = "A fork of XCompMgr, a sample compositing manager for X servers";
    longDescription = ''
      A fork of XCompMgr, which is a sample compositing manager for X
      servers supporting the XFIXES, DAMAGE, RENDER, and COMPOSITE
      extensions. It enables basic eye-candy effects. This fork adds
      additional features, such as additional effects, and a fork at a
      well-defined and proper place.
    '';
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
