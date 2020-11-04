{ stdenv, fetchgit, fontconfig, libjpeg, libcap, freetype, fribidi, pkgconfig
, gettext, systemd, perl, lib
, enableSystemd ? true
, enableBidi ? true
}: stdenv.mkDerivation rec {

  pname = "vdr";
  version = "2.4.4";

  src = fetchgit {
    url = "git://git.tvdr.de/vdr.git";
    rev = "V20404";
    sha256 = "1fzghnp5mpcwn3a3fyk3w8h15z4f2cnc75247kvxj1c9069mgnwa";
  };

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
