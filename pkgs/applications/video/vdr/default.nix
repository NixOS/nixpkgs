{ stdenv, fetchurl, fontconfig, libjpeg, libcap, freetype, fribidi, pkgconfig
, gettext, systemd, perl, lib, fetchpatch
, enableSystemd ? true
, enableBidi ? true
}: stdenv.mkDerivation rec {

  pname = "vdr";
  version = "2.4.1";

  src = fetchurl {
    url = "ftp://ftp.tvdr.de/vdr/${pname}-${version}.tar.bz2";
    sha256 = "1p51b14aqzncx3xpfg0rjplc48pg7520035i5p6r5zzkqhszihr5";
  };

  patches = [
    # Derived from http://git.tvdr.de/?p=vdr.git;a=commit;h=930c2cd2eb8947413e88404fa94c66e4e1db5ad6
    ./glibc2.31-compat.patch
  ];

  enableParallelBuilding = true;

  postPatch = "substituteInPlace Makefile --replace libsystemd-daemon libsystemd";

  buildInputs = [ fontconfig libjpeg libcap freetype perl ]
  ++ lib.optional enableSystemd systemd
  ++ lib.optional enableBidi fribidi;

  buildFlags = [ "vdr" "i18n" ]
  ++ lib.optional enableSystemd "SDNOTIFY=1"
  ++ lib.optional enableBidi "BIDI=1";

  nativeBuildInputs = [ perl ];

  # plugins uses the same build environment as vdr
  propagatedNativeBuildInputs = [ pkgconfig gettext ];

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX=" # needs to be empty, otherwise plugins try to install at same prefix
  ];

  installTargets = [ "install-pc" "install-bin" "install-doc" "install-i18n"
    "install-includes" ];

  postInstall = ''
    mkdir -p $out/lib/vdr # only needed if vdr is started without any plugin
    mkdir -p $out/share/vdr/conf
    cp *.conf $out/share/vdr/conf
    '';

  outputs = [ "out" "dev" "man" ];

  meta = with lib; {
    homepage = "http://www.tvdr.de/";
    description = "Video Disc Recorder";
    maintainers = [ maintainers.ck3d ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = licenses.gpl2;
  };
}
