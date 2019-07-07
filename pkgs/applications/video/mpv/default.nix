{ config, stdenv, fetchurl, fetchFromGitHub, makeWrapper
, docutils, perl, pkgconfig, python3, which, ffmpeg_4
, freefont_ttf, freetype, libass, libpthreadstubs, mujs
, nv-codec-headers, lua, libuchardet, libiconv ? null, darwin

, waylandSupport ? stdenv.isLinux
  , wayland           ? null
  , wayland-protocols ? null
  , libxkbcommon      ? null

, x11Support ? stdenv.isLinux
  , libGLU_combined ? null
  , libX11          ? null
  , libXext         ? null
  , libXxf86vm      ? null
  , libXrandr       ? null

, cddaSupport ? false
  , libcdio          ? null
  , libcdio-paranoia ? null

, vulkanSupport ? stdenv.isLinux
  , shaderc ? null
  , vulkan-headers ? null
  , vulkan-loader ? null

, alsaSupport        ? stdenv.isLinux, alsaLib       ? null
, bluraySupport      ? true,           libbluray     ? null
, bs2bSupport        ? true,           libbs2b       ? null
, cacaSupport        ? true,           libcaca       ? null
, cmsSupport         ? true,           lcms2         ? null
, drmSupport         ? stdenv.isLinux, libdrm        ? null
, dvdnavSupport      ? stdenv.isLinux, libdvdnav     ? null
, dvdreadSupport     ? stdenv.isLinux, libdvdread    ? null
, libpngSupport      ? true,           libpng        ? null
, pulseSupport       ? config.pulseaudio or stdenv.isLinux, libpulseaudio ? null
, rubberbandSupport  ? stdenv.isLinux, rubberband ? null
, screenSaverSupport ? true,           libXScrnSaver ? null
, sdl2Support        ? true,           SDL2          ? null
, speexSupport       ? true,           speex         ? null
, theoraSupport      ? true,           libtheora     ? null
, vaapiSupport       ? stdenv.isLinux, libva ? null
, vdpauSupport       ? true,           libvdpau      ? null
, xineramaSupport    ? stdenv.isLinux, libXinerama   ? null
, xvSupport          ? stdenv.isLinux, libXv         ? null
, youtubeSupport     ? true,           youtube-dl    ? null
, archiveSupport     ? false,          libarchive    ? null
, jackaudioSupport   ? false,          libjack2      ? null
, openalSupport      ? false,          openalSoft    ? null
, vapoursynthSupport ? false,          vapoursynth   ? null
}:

with stdenv.lib;

let
  available = x: x != null;
in
assert alsaSupport        -> available alsaLib;
assert archiveSupport     -> available libarchive;
assert bluraySupport      -> available libbluray;
assert bs2bSupport        -> available libbs2b;
assert cacaSupport        -> available libcaca;
assert cddaSupport        -> all available [libcdio libcdio-paranoia];
assert cmsSupport         -> available lcms2;
assert drmSupport         -> available libdrm;
assert dvdnavSupport      -> available libdvdnav;
assert dvdreadSupport     -> available libdvdread;
assert jackaudioSupport   -> available libjack2;
assert libpngSupport      -> available libpng;
assert openalSupport      -> available openalSoft;
assert pulseSupport       -> available libpulseaudio;
assert rubberbandSupport  -> available rubberband;
assert screenSaverSupport -> available libXScrnSaver;
assert sdl2Support        -> available SDL2;
assert speexSupport       -> available speex;
assert theoraSupport      -> available libtheora;
assert vaapiSupport       -> available libva;
assert vapoursynthSupport -> available vapoursynth;
assert vdpauSupport       -> available libvdpau;
assert waylandSupport     -> all available [ wayland wayland-protocols libxkbcommon ];
assert x11Support         -> all available [ libGLU_combined libX11 libXext libXxf86vm libXrandr ];
assert xineramaSupport    -> x11Support && available libXinerama;
assert xvSupport          -> x11Support && available libXv;
assert youtubeSupport     -> available youtube-dl;

let
  # Purity: Waf is normally downloaded by bootstrap.py, but
  # for purity reasons this behavior should be avoided.
  wafVersion = "2.0.9";
  waf = fetchurl {
    urls = [ "https://waf.io/waf-${wafVersion}"
             "http://www.freehackers.org/~tnagy/release/waf-${wafVersion}" ];
    sha256 = "0j7sbn3w6bgslvwwh5v9527w3gi2sd08kskrgxamx693y0b0i3ia";
  };
  luaEnv = lua.withPackages(ps: with ps; [ luasocket ]);

in stdenv.mkDerivation rec {
  name = "mpv-${version}";
  version = "0.29.1";

  src = fetchFromGitHub {
    owner = "mpv-player";
    repo  = "mpv";
    rev    = "v${version}";
    sha256 = "138921kx8g6qprim558xin09xximjhsj9ss8b71ifg2m6kclym8m";
  };

  postPatch = ''
    patchShebangs ./TOOLS/
  '';

  NIX_LDFLAGS = optionalString x11Support "-lX11 -lXext "
              + optionalString stdenv.isDarwin "-framework CoreFoundation";

  configureFlags = [
    "--enable-libmpv-shared"
    "--enable-manpage-build"
    "--enable-zsh-comp"
    "--disable-libmpv-static"
    "--disable-static-build"
    "--disable-build-date" # Purity
    "--disable-macos-cocoa-cb" # Disable whilst Swift isn't supported
    (enableFeature archiveSupport  "libarchive")
    (enableFeature cddaSupport     "cdda")
    (enableFeature dvdnavSupport   "dvdnav")
    (enableFeature dvdreadSupport  "dvdread")
    (enableFeature openalSupport   "openal")
    (enableFeature vaapiSupport    "vaapi")
    (enableFeature waylandSupport  "wayland")
    (enableFeature stdenv.isLinux  "dvbin")
  ];

  configurePhase = ''
    python3 ${waf} configure --prefix=$out $configureFlags
  '';

  nativeBuildInputs = [
    docutils makeWrapper perl
    pkgconfig python3 which
  ];

  buildInputs = [
    ffmpeg_4 freetype libass libpthreadstubs
    luaEnv libuchardet mujs
  ] ++ optional alsaSupport        alsaLib
    ++ optional archiveSupport     libarchive
    ++ optional bluraySupport      libbluray
    ++ optional bs2bSupport        libbs2b
    ++ optional cacaSupport        libcaca
    ++ optional cmsSupport         lcms2
    ++ optional drmSupport         libdrm
    ++ optional dvdreadSupport     libdvdread
    ++ optional jackaudioSupport   libjack2
    ++ optional libpngSupport      libpng
    ++ optional openalSupport      openalSoft
    ++ optional pulseSupport       libpulseaudio
    ++ optional rubberbandSupport  rubberband
    ++ optional screenSaverSupport libXScrnSaver
    ++ optional sdl2Support        SDL2
    ++ optional speexSupport       speex
    ++ optional theoraSupport      libtheora
    ++ optional vaapiSupport       libva
    ++ optional vapoursynthSupport vapoursynth
    ++ optional vdpauSupport       libvdpau
    ++ optional xineramaSupport    libXinerama
    ++ optional xvSupport          libXv
    ++ optional youtubeSupport     youtube-dl
    ++ optional stdenv.isDarwin    libiconv
    ++ optional stdenv.isLinux     nv-codec-headers
    ++ optionals cddaSupport       [ libcdio libcdio-paranoia ]
    ++ optionals dvdnavSupport     [ libdvdnav libdvdnav.libdvdread ]
    ++ optionals waylandSupport    [ wayland wayland-protocols libxkbcommon ]
    ++ optionals x11Support        [ libX11 libXext libGLU_combined libXxf86vm libXrandr ]
    ++ optionals vulkanSupport     [ shaderc vulkan-headers vulkan-loader ]
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      CoreFoundation Cocoa CoreAudio
    ]);

  enableParallelBuilding = true;

  buildPhase = ''
    python3 ${waf} build
  '' + optionalString stdenv.isDarwin ''
    python3 TOOLS/osxbundle.py -s build/mpv
  '';

  # Ensure youtube-dl is available in $PATH for mpv
  wrapperFlags =

    ''--prefix PATH : "${luaEnv}/bin" \''
  + optionalString youtubeSupport ''
      --prefix PATH : "${youtube-dl}/bin" \
  '' + optionalString vapoursynthSupport ''
      --prefix PYTHONPATH : "${vapoursynth}/lib/${python3.libPrefix}/site-packages:$PYTHONPATH"
  '';

  installPhase = ''
    python3 ${waf} install

    # Use a standard font
    mkdir -p $out/share/mpv
    ln -s ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mpv/subfont.ttf
    wrapProgram "$out/bin/mpv" \
      ${wrapperFlags}

    cp TOOLS/umpv $out/bin
    wrapProgram $out/bin/umpv \
      --set MPV "$out/bin/mpv"

  '' + optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -r build/mpv.app $out/Applications
    wrapProgram "$out/Applications/mpv.app/Contents/MacOS/mpv" \
      ${wrapperFlags}
  '';

  meta = with stdenv.lib; {
    description = "A media player that supports many video formats (MPlayer and mplayer2 fork)";
    homepage = https://mpv.io;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres fuuzetsu fpletz ];
    platforms = platforms.darwin ++ platforms.linux;

    longDescription = ''
      mpv is a free and open-source general-purpose video player,
      based on the MPlayer and mplayer2 projects, with great
      improvements above both.
    '';
  };
}
