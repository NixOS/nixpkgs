{ stdenv, fetchurl, intltool, pkgconfig, gtk, libglade, libosip, libexosip
, speex, readline, mediastreamer, libsoup }:

stdenv.mkDerivation rec {
  name = "linphone-3.5.2";

  src = fetchurl {
    url = "mirror://savannah/linphone/3.5.x/sources/${name}.tar.gz";
    sha256 = "0830iam7kgqphgk3q6qx93kp5wrf0gnm5air82jamy7377jxadys";
  };

  patches = [ ./fix-deprecated.patch ];

  buildInputs = [ gtk libglade libosip libexosip readline mediastreamer speex libsoup ];

  nativeBuildInputs = [ intltool pkgconfig ];

  preConfigure = "rm -r mediastreamer2 oRTP";

  configureFlags = "--enable-external-ortp --enable-external-mediastreamer";

  meta = {
    homepage = http://www.linphone.org/;
    description = "Open Source video SIP softphone";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.gnu;
  };
}
