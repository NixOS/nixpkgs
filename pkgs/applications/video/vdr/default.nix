{ stdenv, fetchurl, fontconfig, libjpeg, libcap, freetype, fribidi, pkgconfig
, gettext, ncurses, systemd, perl
, enableSystemd ? true
, enableBidi ? true
}:
let

  version = "2.4.0";

  name = "vdr-${version}";

  mkPlugin = name: stdenv.mkDerivation {
    name = "vdr-${name}-${version}";
    inherit (vdr) src patches;
    buildInputs = [ gettext vdr ];
    nativeBuildInputs = [ pkgconfig ];
    preConfigure = "cd PLUGINS/src/${name}";
    installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];
  };

  vdr = stdenv.mkDerivation {

    inherit name;

    src = fetchurl {
      url = "ftp://ftp.tvdr.de/vdr/${name}.tar.bz2";
      sha256 = "1klcgy9kr7n6z8d2c77j63bl8hvhx5qnqppg73f77004hzz4kbwk";
    };

    enableParallelBuilding = true;

    postPatch = "substituteInPlace Makefile --replace libsystemd-daemon libsystemd";

    buildInputs = [ fontconfig libjpeg libcap freetype perl ]
      ++ stdenv.lib.optional enableSystemd systemd
      ++ stdenv.lib.optional enableBidi fribidi;

    buildFlags = [ "vdr" "i18n" ]
      ++ stdenv.lib.optional enableSystemd "SDNOTIFY=1"
      ++ stdenv.lib.optional enableBidi "BIDI=1";

    propagatedBuildInputs = [ pkgconfig gettext ];

    installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

    installTargets = [ "install-pc" "install-bin" "install-doc" "install-i18n"
      "install-includes" ];

    postInstall = ''
      mkdir -p $out/lib/vdr # only needed if vdr is started without any plugin
      mkdir -p $out/share/vdr/conf
      cp *.conf $out/share/vdr/conf
      '';

    outputs = [ "out" "dev" "man" ];

    meta = with stdenv.lib; {
      homepage = http://www.tvdr.de/;
      description = "Video Disc Recorder";
      maintainers = [ maintainers.ck3d ];
      platforms = [ "i686-linux" "x86_64-linux" ];
      license = licenses.gpl2;
    };

  };
in {
  inherit vdr;
  skincurses = (mkPlugin "skincurses").overrideAttrs(
    oldAttr: { buildInputs = oldAttr.buildInputs ++ [ ncurses ]; });
} // stdenv.lib.genAttrs [ "epgtableid0" "hello" "osddemo"
  "pictures" "servicedemo" "status" "svdrpdemo" ] mkPlugin
