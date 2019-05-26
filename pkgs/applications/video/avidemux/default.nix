{ stdenv, lib, fetchurl, cmake, pkgconfig
, zlib, gettext, libvdpau, libva, libXv, sqlite
, yasm, freetype, fontconfig, fribidi
, makeWrapper, libXext, libGLU, qttools, qtbase
, alsaLib
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
, withQT ? true
, withCLI ? true
, default ? "qt5"
, withPlugins ? true
}:

assert withQT -> qttools != null && qtbase != null;
assert default != "qt5" -> default == "cli";
assert !withQT -> default != "qt5";

stdenv.mkDerivation rec {
  name = "avidemux-${version}";
  version = "2.7.3";

  src = fetchurl {
    url = "mirror://sourceforge/avidemux/avidemux/${version}/avidemux_${version}.tar.gz";
    sha256 = "17x2mnnr5h8pp764p55l1xcn2ljnzhbj8cykajlllvk4rc4qwxld";
  };

  patches = [
    ./dynamic_install_dir.patch
    ./bootstrap_logging.patch
  ];

  nativeBuildInputs = [ yasm cmake pkgconfig ];
  buildInputs = [
    zlib gettext libvdpau libva libXv sqlite fribidi fontconfig
    freetype alsaLib libXext libGLU makeWrapper
  ] ++ lib.optional withX264 x264
    ++ lib.optional withX265 x265
    ++ lib.optional withXvid xvidcore
    ++ lib.optional withLAME lame
    ++ lib.optional withFAAC faac
    ++ lib.optional withVorbis libvorbis
    ++ lib.optional withPulse libpulseaudio
    ++ lib.optional withFAAD faad2
    ++ lib.optional withOpus libopus
    ++ lib.optionals withQT [ qttools qtbase ]
    ++ lib.optional withVPX libvpx;

  buildCommand = let
    qtVersion = "5.${stdenv.lib.versions.minor qtbase.version}";
    wrapProgram = f: "wrapProgram ${f} --set ADM_ROOT_DIR $out --prefix LD_LIBRARY_PATH : ${libXext}/lib";
  in ''
    unpackPhase
    cd "$sourceRoot"
    patchPhase

    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${libXext}/lib"
    ${stdenv.shell} bootStrap.bash \
      --with-core \
      ${if withQT then "--with-qt" else "--without-qt"} \
      ${if withCLI then "--with-cli" else "--without-cli"} \
      ${if withPlugins then "--with-plugins" else "--without-plugins"}

    mkdir $out
    cp -R install/usr/* $out

    ${wrapProgram "$out/bin/avidemux3_cli"}

    ${stdenv.lib.optionalString withQT ''
      ${wrapProgram "$out/bin/avidemux3_qt5"} --prefix QT_PLUGIN_PATH : ${qtbase}/lib/qt-${qtVersion}/plugins
      ${wrapProgram "$out/bin/avidemux3_jobs_qt5"} --prefix QT_PLUGIN_PATH : ${qtbase}/lib/qt-${qtVersion}/plugins
    ''}

    ln -s "$out/bin/avidemux3_${default}" "$out/bin/avidemux"

    fixupPhase
  '';

  meta = with stdenv.lib; {
    homepage = http://fixounet.free.fr/avidemux/;
    description = "Free video editor designed for simple video editing tasks";
    maintainers = with maintainers; [ abbradar ma27 ];
    # "CPU not supported" errors on AArch64
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = licenses.gpl2;
  };
}
