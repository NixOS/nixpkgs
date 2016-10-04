{ stdenv, fetchgit, vlc, autoconf, automake, libtool, pkgconfig, npapi_sdk,
libxcb, xlibsWrapper, gtk}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "vlc-plugin-${version}";
  version = "2.2.2"; # This 2.2.2 builds fine with vlc 2.2.4

  src = fetchgit {
    url = "https://code.videolan.org/videolan/npapi-vlc.git";
    rev = "5fa6fbc11cf5bad983f57656c0085e47e18fbf20";
    sha256 = "0k4s0657kv1mx1md8vj87scs0hz59xy7syqdsxb48w3w8gnfljs0";
  };

  preConfigure = "sh autogen.sh";

  buildInputs = [ vlc autoconf automake libtool pkgconfig npapi_sdk libxcb
      xlibsWrapper gtk ];

  enableParallelBuilding = true;

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  meta = with stdenv.lib; {
    description = "Webplugins based on libVLC (for firefox, npapi)";
    homepage = https://code.videolan.org/videolan/npapi-vlc;
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
