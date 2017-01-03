{ stdenv, lib, fetchurl, cmake, pkgconfig, lndir
, zlib, gettext, libvdpau, libva, libXv, sqlite
, yasm, freetype, fontconfig, fribidi, gtk3, qt4
, withX265 ? true, x265
, withX264 ? true, x264
, withXvid ? true, xvidcore
, withLAME ? true, lame
, withFAAC ? false, faac
, withVorbis ? true, libvorbis
, withPulse ? true, libpulseaudio
, withFAAD ? true, faad2
, withOpus ? true, libopus
, withVPX ? true, libvpx
}:

let
  version = "2.6.16";

  src = fetchurl {
    url = "mirror://sourceforge/avidemux/avidemux/${version}/avidemux_${version}.tar.gz";
    sha256 = "0jipvpvw871qhhkyykrrrqc9vfbw24v243vzmm8lqifj73h6qvgc";
  };

  common = {
    inherit version src;

    patches = [ ./dynamic_install_dir.patch ];

    enableParallelBuilding = false;

    nativeBuildInputs = [ cmake pkgconfig yasm ];
    buildInputs = [ zlib gettext libvdpau libva libXv sqlite fribidi fontconfig freetype ]
                  ++ lib.optional withX264 x264
                  ++ lib.optional withX265 x265
                  ++ lib.optional withXvid xvidcore
                  ++ lib.optional withLAME lame
                  ++ lib.optional withFAAC faac
                  ++ lib.optional withVorbis libvorbis
                  ++ lib.optional withPulse libpulseaudio
                  ++ lib.optional withFAAD faad2
                  ++ lib.optional withOpus libopus
                  ++ lib.optional withVPX libvpx
                  ;

    meta = {
      homepage = http://fixounet.free.fr/avidemux/;
      description = "Free video editor designed for simple video editing tasks";
      maintainers = with stdenv.lib.maintainers; [ viric abbradar ];
      platforms = with stdenv.lib.platforms; linux;
      license = stdenv.lib.licenses.gpl2;
    };
  };

  core = stdenv.mkDerivation (common // {
    name = "avidemux-${version}";

    preConfigure = ''
      cd avidemux_core
    '';
  });

  buildPlugin = args: stdenv.mkDerivation (common // {
    name = "avidemux-${args.pluginName}-${version}";

    buildInputs = (args.buildInputs or []) ++ common.buildInputs ++ [ lndir ];

    cmakeFlags = [ "-DPLUGIN_UI=${args.pluginUi}" ];

    passthru.isUi = args.isUi or false;

    buildCommand = ''
      unpackPhase
      cd "$sourceRoot"
      patchPhase

      mkdir $out
      lndir ${core} $out

      export cmakeFlags="$cmakeFlags -DAVIDEMUX_SOURCE_DIR=$(pwd)"

      for i in ${toString (args.buildDirs or [])} avidemux_plugins; do
        ( cd "$i"
          cmakeConfigurePhase
          buildPhase
          installPhase
        )
      done

      fixupPhase
    '';
  });

in {
  avidemux_core = core;

  avidemux_cli = buildPlugin {
    pluginName = "cli";
    pluginUi = "CLI";
    isUi = true;
    buildDirs = [ "avidemux/cli" ];
  };

  avidemux_qt4 = buildPlugin {
    pluginName = "qt4";
    buildInputs = [ qt4 ];
    pluginUi = "QT4";
    isUi = true;
    buildDirs = [ "avidemux/qt4" ];
  };

  avidemux_gtk = buildPlugin {
    pluginName = "gtk";
    buildInputs = [ gtk3 ];
    pluginUi = "GTK";
    isUi = true;
    buildDirs = [ "avidemux/gtk" ];
  };

  avidemux_common = buildPlugin {
    pluginName = "common";
    pluginUi = "COMMON";
  };

  avidemux_settings = buildPlugin {
    pluginName = "settings";
    pluginUi = "SETTINGS";
  };
}
