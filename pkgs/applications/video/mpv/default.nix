{ stdenv, fetchurl, fetchgit, freetype, pkgconfig, freefont_ttf, ffmpeg, libass
, lua, perl, libpthreadstubs
, lua5_sockets
, python3, docutils, which, lib
, x11Support ? true, libX11 ? null, libXext ? null, mesa ? null, libXxf86vm ? null
, xineramaSupport ? true, libXinerama ? null
, xvSupport ? true, libXv ? null
, sdl2Support? true, SDL2 ? null
, alsaSupport ? true, alsaLib ? null
, screenSaverSupport ? true, libXScrnSaver ? null
, vdpauSupport ? true, libvdpau ? null
, dvdreadSupport? true, libdvdread ? null
, dvdnavSupport ? true, libdvdnav ? null
, bluraySupport ? true, libbluray ? null
, speexSupport ? true, speex ? null
, theoraSupport ? true, libtheora ? null
, jackaudioSupport ? true, jack2 ? null
, pulseSupport ? true, pulseaudio ? null
, bs2bSupport ? false, libbs2b ? null
# For screenshots
, libpngSupport ? true, libpng ? null
# for Youtube support
, quviSupport ? false, libquvi ? null
, cacaSupport ? false, libcaca ? null
, vaapiSupport ? false, libva ? null
}:

assert x11Support -> (libX11 != null && libXext != null && mesa != null && libXxf86vm != null);
assert xineramaSupport -> (libXinerama != null && x11Support);
assert xvSupport -> (libXv != null && x11Support);
assert sdl2Support -> SDL2 != null;
assert alsaSupport -> alsaLib != null;
assert screenSaverSupport -> libXScrnSaver != null;
assert vdpauSupport -> libvdpau != null;
assert dvdreadSupport -> libdvdread != null;
assert dvdnavSupport -> libdvdnav != null;
assert bluraySupport -> libbluray != null;
assert speexSupport -> speex != null;
assert theoraSupport -> libtheora != null;
assert jackaudioSupport -> jack2 != null;
assert pulseSupport -> pulseaudio != null;
assert bs2bSupport -> libbs2b != null;
assert libpngSupport -> libpng != null;
assert quviSupport -> libquvi != null;
assert cacaSupport -> libcaca != null;

# Purity problem: Waf needed to be is downloaded by bootstrap.py
# but by purity reasons it should be avoided; thanks the-kenny to point it out!
# Now, it will just download and package Waf, mimetizing bootstrap.py behaviour

let
  waf = fetchurl {
    url = http://ftp.waf.io/pub/release/waf-1.7.16;
    sha256 = "b64dc26c882572415fd450b745006107965f3fe17b357e3eb43d6676c9635a61";
  };

in

stdenv.mkDerivation rec {
  name = "mpv-${version}";
  version = "0.6.1";

  src = fetchurl {
    url = "https://github.com/mpv-player/mpv/archive/v${version}.tar.gz";
    sha256 = "03vzsvvb1dvm4rn70m97fdbzhlqj9crk7zpvcp00bcl956xjfc9s";
  };

  buildInputs = with stdenv.lib;
    [ waf python3 lua perl freetype pkgconfig ffmpeg libass docutils which libpthreadstubs lua5_sockets ]
    ++ optionals x11Support [ libX11 libXext mesa libXxf86vm ]
    ++ optional alsaSupport alsaLib
    ++ optional xvSupport libXv
    ++ optional theoraSupport libtheora
    ++ optional xineramaSupport libXinerama
    ++ optional dvdreadSupport libdvdread
    ++ optionals dvdnavSupport [ libdvdnav libdvdnav.libdvdread ]
    ++ optional bluraySupport libbluray
    ++ optional jackaudioSupport jack2
    ++ optional pulseSupport pulseaudio
    ++ optional screenSaverSupport libXScrnSaver
    ++ optional vdpauSupport libvdpau
    ++ optional speexSupport speex
    ++ optional bs2bSupport libbs2b
    ++ optional libpngSupport libpng
    ++ optional quviSupport libquvi
    ++ optional sdl2Support SDL2
    ++ optional cacaSupport libcaca
    ++ optional vaapiSupport libva
    ;

# There are almost no need of "configure flags", but some libraries
# weren't detected; see the TODO comments below

  NIX_LDFLAGS = stdenv.lib.optionalString x11Support "-lX11 -lXext";

  enableParallelBuilding = true;

  configurePhase = ''
    python3 ${waf} configure --prefix=$out ${lib.optionalString vaapiSupport "--enable-vaapi"}
    patchShebangs TOOLS
  '';

  buildPhase = ''
    python3 ${waf} build
  '';

  installPhase = ''
    python3 ${waf} install
    # Maybe not needed, but it doesn't hurt anyway: a standard font
    mkdir -p $out/share/mpv
    ln -s ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mpv/subfont.ttf
    '';

  meta = with stdenv.lib;{
    description = "A movie player that supports many video formats (MPlayer and mplayer2 fork)";
    longDescription = ''
      mpv is a free and open-source general-purpose video player,
      based on the MPlayer and mplayer2 projects, with great
      improvements above both.
    '';
    homepage = http://mpv.io;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}

# TODO: Wayland support
# TODO: investigate libquvi problems (related to Youtube support)
# TODO: investigate caca support
# TODO: investigate lua5_sockets bug
