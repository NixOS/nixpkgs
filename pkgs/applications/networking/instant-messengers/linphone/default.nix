{ stdenv, fetchurl, intltool, pkgconfig, gtk, libglade, libosip, libexosip
, speex, readline, mediastreamer, libsoup, udev, libnotify }:

stdenv.mkDerivation rec {
  name = "linphone-3.6.1";

  src = fetchurl {
    url = "mirror://savannah/linphone/3.6.x/sources/${name}.tar.gz";
    sha256 = "186jm4nd4ggb0j8cs8wnpm4sy9cr7chq0c6kx2yc6y4k7qi83fh5";
  };

  buildInputs = [ gtk libglade libosip libexosip readline mediastreamer speex libsoup udev
    libnotify ];

  nativeBuildInputs = [ intltool pkgconfig ];

  preConfigure = ''
    rm -r mediastreamer2 oRTP
    sed -i s,/bin/echo,echo, coreapi/Makefile*
  '';

  configureFlags = "--enable-external-ortp --enable-external-mediastreamer";

  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations"; # I'm lazy to fix these for them

  meta = {
    homepage = http://www.linphone.org/;
    description = "Open Source video SIP softphone";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.gnu;
  };
}
