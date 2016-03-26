{ stdenv, lib, fetchurl, cmake, pkgconfig, lndir
, zlib, gettext, libvdpau, libva, libXv, sqlite, x265
, yasm, fribidi, gtk3, qt4
, withX264 ? true, x264
, withLAME ? true, lame
, withFAAC ? true, faac
, withVorbis ? true, libvorbis
, withPulse ? true, libpulseaudio
, withFAAD ? true, faad2
, withOpus ? true, libopus
, withVPX ? true, libvpx
}:

stdenv.mkDerivation rec {
  name = "avidemux-${version}";
  version = "2.6.12";

  src = fetchurl {
    url = "mirror://sourceforge/avidemux/avidemux/${version}/avidemux_${version}.tar.gz";
    sha256 = "0nz52yih8sff53inndkh2dba759xjzsh4b8xjww419lcpk0qp6kn";
  };

  nativeBuildInputs = [ cmake pkgconfig yasm lndir ];
  buildInputs = [ zlib gettext libvdpau libva libXv sqlite x265 fribidi gtk3 qt4 ]
             ++ lib.optional withX264 x264
             ++ lib.optional withLAME lame
             ++ lib.optional withFAAC faac
             ++ lib.optional withVorbis libvorbis
             ++ lib.optional withPulse libpulseaudio
             ++ lib.optional withFAAD faad2
             ++ lib.optional withOpus libopus
             ++ lib.optional withVPX libvpx
             ;

  enableParallelBuilding = false;

  outputs = [ "out" "cli" "gtk" "qt4" ];

  patches = [ ./dynamic_install_dir.patch ];

  buildCommand = ''
    unpackPhase
    cd "$sourceRoot"
    patchPhase

    export cmakeFlags="$cmakeFlags -DAVIDEMUX_SOURCE_DIR=$(pwd)"

    function buildOutput() {
      ( plugin_ui="$1"
        output_dir="$2"
        shift 2
        export cmakeFlags="$cmakeFlags -DPLUGIN_UI=$plugin_ui -DCMAKE_INSTALL_PREFIX=$output_dir"
        for i in "$@" avidemux_plugins; do
          ( cd "$i"
            cmakeConfigurePhase
            buildPhase
            installPhase
          )
        done
        rm -rf avidemux_plugins/build
      )
    }

    function buildUi() {
      plugin_ui="$1"
      output_dir="$2"
      shift 2

      # Hack to split builds properly
      mkdir -p $output_dir
      lndir $out $output_dir
      buildOutput $plugin_ui $output_dir "$@"
    }

    function fixupUi() {
      output_dir="$1"
      shift

      find $output_dir -lname $out\* -delete
      find $output_dir -type f | while read -r f; do
        rpath="$(patchelf --print-rpath $f 2>/dev/null)" || continue
        new_rpath=""
        IFS=':' read -ra old_rpath <<< "$rpath"
        for p in "''${old_rpath[@]}"; do
          new_rpath="$new_rpath:$p"
          if [[ $p = $output_dir* ]]; then
            new_rpath="$new_rpath:$out/''${p#$output_dir}"
          fi
        done
        patchelf --set-rpath "$new_rpath" $f
        patchelf --shrink-rpath $f
      done
    }

    buildOutput COMMON $out avidemux_core
    buildOutput SETTINGS $out
    buildUi CLI $cli avidemux/cli
    buildUi GTK $gtk avidemux/gtk
    buildUi QT4 $qt4 avidemux/qt4

    fixupPhase

    fixupUi $cli
    fixupUi $gtk
    fixupUi $qt4
  '';

  meta = {
    homepage = http://fixounet.free.fr/avidemux/;
    description = "Free video editor designed for simple video editing tasks";
    maintainers = with stdenv.lib.maintainers; [ viric abbradar ];
    platforms = with stdenv.lib.platforms; linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
