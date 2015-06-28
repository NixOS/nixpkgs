{ stdenv, fetchurl, docutils, makeWrapper, perl, pkgconfig, python, which
, ffmpeg, freefont_ttf, freetype, libass, libpthreadstubs, lua, lua5_sockets
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
, jackaudioSupport ? true, libjack2 ? null
, pulseSupport ? true, libpulseaudio ? null
, bs2bSupport ? true, libbs2b ? null
# For screenshots
, libpngSupport ? true, libpng ? null
# for Youtube support
, youtubeSupport ? true, youtube-dl ? null
, cacaSupport ? true, libcaca ? null
, vaapiSupport ? false, libva ? null
}:

# TODO: Wayland support
# TODO: investigate caca support
# TODO: investigate lua5_sockets bug

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

let
  inherit (stdenv.lib) optional optionals optionalString;

  # Purity: Waf is normally downloaded by bootstrap.py, but
  # for purity reasons this behavior should be avoided.
  waf = fetchurl {
    url = http://ftp.waf.io/pub/release/waf-1.8.5;
    sha256 = "0gh266076pd9fzwkycskyd3kkv2kds9613blpxmn9w4glkiwmmh5";
  };
in

stdenv.mkDerivation rec {
  name = "mpv-${version}";
  version = "0.9.2";

  src = fetchurl {
    url = "https://github.com/mpv-player/mpv/archive/v${version}.tar.gz";
    sha256 = "0la7pmy75mq92kcrawdiw5idw6a46z7d15mlkgs0axyivdaqy560";
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
  ] ++ optional vaapiSupport "--enable-vaapi";

  configurePhase = ''
    python ${waf} configure --prefix=$out $configureFlags
  '';

  nativeBuildInputs = [ docutils makeWrapper perl pkgconfig python which ];

  buildInputs = [
    ffmpeg freetype libass libpthreadstubs lua lua5_sockets
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
    ++ optional vaapiSupport libva;

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
