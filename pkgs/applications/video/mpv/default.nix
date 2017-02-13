{ stdenv, fetchurl, fetchFromGitHub, makeWrapper
, docutils, perl, pkgconfig, python3, which, ffmpeg
, freefont_ttf, freetype, libass, libpthreadstubs
, lua, lua5_sockets, libuchardet, libiconv ? null, darwin

, x11Support ? true,
    mesa       ? null,
    libX11     ? null,
    libXext    ? null,
    libXxf86vm ? null

, waylandSupport ? false,
    wayland      ? null,
    libxkbcommon ? null

, rubberbandSupport  ? !stdenv.isDarwin, rubberband ? null
, xineramaSupport    ? true,  libXinerama   ? null
, xvSupport          ? true,  libXv         ? null
, sdl2Support        ? true,  SDL2          ? null
, alsaSupport        ? !stdenv.isDarwin,  alsaLib       ? null
, screenSaverSupport ? true,  libXScrnSaver ? null
, vdpauSupport       ? true,  libvdpau      ? null
, dvdreadSupport     ? !stdenv.isDarwin,  libdvdread    ? null
, dvdnavSupport      ? dvdreadSupport,  libdvdnav     ? null
, bluraySupport      ? true,  libbluray     ? null
, speexSupport       ? true,  speex         ? null
, theoraSupport      ? true,  libtheora     ? null
, pulseSupport       ? !stdenv.isDarwin,  libpulseaudio ? null
, bs2bSupport        ? true,  libbs2b       ? null
, cacaSupport        ? true,  libcaca       ? null
, libpngSupport      ? true,  libpng        ? null
, youtubeSupport     ? true,  youtube-dl    ? null
, vaapiSupport       ? true,  libva         ? null
, vapoursynthSupport ? false, vapoursynth   ? null
, jackaudioSupport   ? false, libjack2      ? null

# scripts you want to be loaded by default
, scripts ? []
}:

with stdenv.lib;

let
  available = x: x != null;
in
assert x11Support         -> all available [mesa libX11 libXext libXxf86vm];
assert waylandSupport     -> all available [wayland libxkbcommon];
assert rubberbandSupport  -> available rubberband;
assert xineramaSupport    -> x11Support && available libXinerama;
assert xvSupport          -> x11Support && available libXv;
assert sdl2Support        -> available SDL2;
assert alsaSupport        -> available alsaLib;
assert screenSaverSupport -> available libXScrnSaver;
assert vdpauSupport       -> available libvdpau;
assert dvdreadSupport     -> available libdvdread;
assert dvdnavSupport      -> available libdvdnav;
assert bluraySupport      -> available libbluray;
assert speexSupport       -> available speex;
assert theoraSupport      -> available libtheora;
assert pulseSupport       -> available libpulseaudio;
assert bs2bSupport        -> available libbs2b;
assert cacaSupport        -> available libcaca;
assert libpngSupport      -> available libpng;
assert youtubeSupport     -> available youtube-dl;
assert vapoursynthSupport -> available vapoursynth;
assert jackaudioSupport   -> available libjack2;
assert vaapiSupport       -> available libva;

let
  # Purity: Waf is normally downloaded by bootstrap.py, but
  # for purity reasons this behavior should be avoided.
  wafVersion = "1.8.12";
  waf = fetchurl {
    urls = [ "http://waf.io/waf-${wafVersion}"
             "http://www.freehackers.org/~tnagy/release/waf-${wafVersion}" ];
    sha256 = "12y9c352zwliw0zk9jm2lhynsjcf5jy0k1qch1c1av8hnbm2pgq1";
  };
in stdenv.mkDerivation rec {
  name = "mpv-${version}";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "mpv-player";
    repo  = "mpv";
    rev    = "v${version}";
    sha256 = "1v1qfppysi0qn40q9z7cx9gs7pcrz2hn1g44iynygvgj29h1gify";
  };

  patchPhase = ''
    patchShebangs ./TOOLS/
  '';

  NIX_LDFLAGS = optionalString x11Support "-lX11 -lXext";

  configureFlags = [
    "--enable-libmpv-shared"
    "--enable-manpage-build"
    "--enable-zsh-comp"
    "--disable-libmpv-static"
    "--disable-static-build"
    "--disable-build-date" # Purity
    (enableFeature vaapiSupport "vaapi")
    (enableFeature waylandSupport "wayland")
  ];

  configurePhase = ''
    python3 ${waf} configure --prefix=$out $configureFlags
  '';

  nativeBuildInputs = [ docutils makeWrapper perl pkgconfig python3 which ];

  buildInputs = [
    ffmpeg freetype libass libpthreadstubs
    lua lua5_sockets libuchardet
  ] ++ optional alsaSupport        alsaLib
    ++ optional xvSupport          libXv
    ++ optional theoraSupport      libtheora
    ++ optional xineramaSupport    libXinerama
    ++ optional dvdreadSupport     libdvdread
    ++ optional bluraySupport      libbluray
    ++ optional jackaudioSupport   libjack2
    ++ optional pulseSupport       libpulseaudio
    ++ optional stdenv.isDarwin    libiconv
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
       Cocoa CoreAudio ])
    ++ optional rubberbandSupport  rubberband
    ++ optional screenSaverSupport libXScrnSaver
    ++ optional vdpauSupport       libvdpau
    ++ optional speexSupport       speex
    ++ optional bs2bSupport        libbs2b
    ++ optional libpngSupport      libpng
    ++ optional youtubeSupport     youtube-dl
    ++ optional sdl2Support        SDL2
    ++ optional cacaSupport        libcaca
    ++ optional vaapiSupport       libva
    ++ optional vapoursynthSupport vapoursynth
    ++ optionals dvdnavSupport     [ libdvdnav libdvdnav.libdvdread ]
    ++ optionals x11Support        [ libX11 libXext mesa libXxf86vm ]
    ++ optionals waylandSupport    [ wayland libxkbcommon ];

  enableParallelBuilding = true;

  buildPhase = ''
    python3 ${waf} build
  '';

  installPhase = ''
    python3 ${waf} install

    # Use a standard font
    mkdir -p $out/share/mpv
    ln -s ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mpv/subfont.ttf
    # Ensure youtube-dl is available in $PATH for MPV
    wrapProgram $out/bin/mpv \
      --add-flags "--script=${concatStringsSep "," scripts}" \
  '' + optionalString youtubeSupport ''
      --prefix PATH : "${youtube-dl}/bin" \
  '' + optionalString vapoursynthSupport ''
      --prefix PYTHONPATH : "$(toPythonPath ${vapoursynth}):$PYTHONPATH"
  '';

  meta = with stdenv.lib; {
    description = "A media player that supports many video formats (MPlayer and mplayer2 fork)";
    homepage = http://mpv.io;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres fuuzetsu ];
    platforms = platforms.darwin ++ platforms.linux;

    longDescription = ''
      mpv is a free and open-source general-purpose video player,
      based on the MPlayer and mplayer2 projects, with great
      improvements above both.
    '';
  };
}
# TODO: investigate caca support
# TODO: investigate lua5_sockets bug
