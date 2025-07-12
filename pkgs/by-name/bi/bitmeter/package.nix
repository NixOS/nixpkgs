{
  lib,
  stdenv,
  autoreconfHook,
  fetchurl,
  libjack2,
  gtk2,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "bitmeter";
  version = "1.2";

  src = fetchurl {
    url = "https://devel.tlrmx.org/audio/source/${pname}-${version}.tar.gz";
    sha256 = "09ck2gxqky701dc1p0ip61rrn16v0pdc7ih2hc2sd63zcw53g2a7";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libjack2
    gtk2
  ];

  patches = [
    (fetchurl {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-sound/bitmeter/files/bitmeter-1.2-fix-build-system.patch?id=dec60bb6900d6ebdaaa6aa1dcb845b30b739f9b5";
      sha256 = "021mz6933iw7mpk6b9cbjr8naj6smbq1hwqjszlyx72qbwrrid7k";
    })
  ];

  meta = with lib; {
    homepage = "http://devel.tlrmx.org/audio/bitmeter/";
    description = "Also known as jack bitscope. Useful to detect denormals";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    mainProgram = "bitmeter";
  };
}
