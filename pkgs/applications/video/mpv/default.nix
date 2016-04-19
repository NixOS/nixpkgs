{ stdenv, fetchurl, docutils, makeWrapper, perl, pkgconfig, python, which
, ffmpeg, freefont_ttf, freetype, libass, libpthreadstubs, lua, lua5_sockets
, libuchardet, rubberband
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
, jackaudioSupport ? false, libjack2 ? null
, pulseSupport ? true, libpulseaudio ? null
, bs2bSupport ? true, libbs2b ? null
# For screenshots
, libpngSupport ? true, libpng ? null
# for Youtube support
, youtubeSupport ? true, youtube-dl ? null
, cacaSupport ? true, libcaca ? null
, vaapiSupport ? false, libva ? null
, waylandSupport ? false, wayland ? null, libxkbcommon ? null
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
assert jackaudioSupport -> libjack2 != null;
assert pulseSupport -> libpulseaudio != null;
assert bs2bSupport -> libbs2b != null;
assert libpngSupport -> libpng != null;
assert youtubeSupport -> youtube-dl != null;
assert cacaSupport -> libcaca != null;
assert waylandSupport -> (wayland != null && libxkbcommon != null);

let
  inherit (stdenv.lib) optional optionals optionalString;

  # Purity: Waf is normally downloaded by bootstrap.py, but
  # for purity reasons this behavior should be avoided.
  wafVersion = "1.8.12";
  waf = fetchurl {
    urls = [ "http://ftp.waf.io/pub/release/waf-${wafVersion}"
             "http://waf.io/waf-${wafVersion}" ];
    sha256 = "12y9c352zwliw0zk9jm2lhynsjcf5jy0k1qch1c1av8hnbm2pgq1";
  };
in

stdenv.mkDerivation rec {
  name = "mpv-${version}";
  version = "0.17.0";

  src = fetchurl {
    url = "https://github.com/mpv-player/mpv/archive/v${version}.tar.gz";
    sha256 = "0vms3viwqcwl1mrgmf2yy4c69fvv7xpbkyrl693l6zpwynqd4b30";
  };

  patchPhase = ''
    patchShebangs ./TOOLS/
  '';

  NIX_LDFLAGS = optionalString x11Support "-lX11 -lXext";

  configureFlags = [
    "--enable-libmpv-shared"
    "--disable-libmpv-static"
    "--disable-static-build"
    "--enable-manpage-build"
    "--disable-build-date" # Purity
    "--enable-zsh-comp"
  ] ++ optional vaapiSupport "--enable-vaapi"
  ++ optional waylandSupport "--enable-wayland";

  configurePhase = ''
    python ${waf} configure --prefix=$out --confloaddir=/etc/mpv $configureFlags
  '';

  nativeBuildInputs = [ docutils makeWrapper perl pkgconfig python which ];

  buildInputs = [
    ffmpeg freetype libass libpthreadstubs lua lua5_sockets libuchardet rubberband
  ] ++ optionals x11Support [ libX11 libXext mesa libXxf86vm ]
    ++ optional alsaSupport alsaLib
    ++ optional xvSupport libXv
    ++ optional theoraSupport libtheora
    ++ optional xineramaSupport libXinerama
    ++ optional dvdreadSupport libdvdread
    ++ optionals dvdnavSupport [ libdvdnav libdvdnav.libdvdread ]
    ++ optional bluraySupport libbluray
    ++ optional jackaudioSupport libjack2
    ++ optional pulseSupport libpulseaudio
    ++ optional screenSaverSupport libXScrnSaver
    ++ optional vdpauSupport libvdpau
    ++ optional speexSupport speex
    ++ optional bs2bSupport libbs2b
    ++ optional libpngSupport libpng
    ++ optional youtubeSupport youtube-dl
    ++ optional sdl2Support SDL2
    ++ optional cacaSupport libcaca
    ++ optional vaapiSupport libva
    ++ optionals waylandSupport [ wayland libxkbcommon ];

  enableParallelBuilding = true;

  buildPhase = ''
    python ${waf} build
  '';

  installPhase = ''
    python ${waf} install

    # Use a standard font
    mkdir -p $out/share/mpv
    ln -s ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mpv/subfont.ttf
  '' + optionalString youtubeSupport ''
    # Ensure youtube-dl is available in $PATH for MPV
    wrapProgram $out/bin/mpv --prefix PATH : "${youtube-dl}/bin"
  '';

  meta = with stdenv.lib; {
    description = "A media player that supports many video formats (MPlayer and mplayer2 fork)";
    homepage = http://mpv.io;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres fuuzetsu ];
    platforms = platforms.linux;

    longDescription = ''
      mpv is a free and open-source general-purpose video player,
      based on the MPlayer and mplayer2 projects, with great
      improvements above both.
    '';
  };
}
# TODO: investigate caca support
# TODO: investigate lua5_sockets bug
