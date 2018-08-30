{ stdenv, fetchpatch, fetchurl, fetchFromGitHub, makeWrapper
, docutils, perl, pkgconfig, python3, which, ffmpeg_4
, freefont_ttf, freetype, libass, libpthreadstubs
, lua, luasocket, libuchardet, libiconv ? null, darwin

, x11Support ? stdenv.isLinux,
    libGLU_combined       ? null,
    libX11     ? null,
    libXext    ? null,
    libXxf86vm ? null,
    libXrandr  ? null

, waylandSupport ? false
  , wayland           ? null
  , wayland-protocols ? null
  , libxkbcommon      ? null

, rubberbandSupport  ? true,  rubberband    ? null
, xineramaSupport    ? true,  libXinerama   ? null
, xvSupport          ? true,  libXv         ? null
, sdl2Support        ? true,  SDL2          ? null
, alsaSupport        ? true,  alsaLib       ? null
, screenSaverSupport ? true,  libXScrnSaver ? null
, cmsSupport         ? true,  lcms2         ? null
, vdpauSupport       ? true,  libvdpau      ? null
, dvdreadSupport     ? true,  libdvdread    ? null
, dvdnavSupport      ? true,  libdvdnav     ? null
, bluraySupport      ? true,  libbluray     ? null
, speexSupport       ? true,  speex         ? null
, theoraSupport      ? true,  libtheora     ? null
, pulseSupport       ? true,  libpulseaudio ? null
, bs2bSupport        ? true,  libbs2b       ? null
, cacaSupport        ? true,  libcaca       ? null
, libpngSupport      ? true,  libpng        ? null
, youtubeSupport     ? true,  youtube-dl    ? null
, vaapiSupport       ? true,  libva         ? null
, drmSupport         ? true,  libdrm        ? null
, openalSupport      ? false, openalSoft    ? null
, vapoursynthSupport ? false, vapoursynth   ? null
, archiveSupport     ? false, libarchive    ? null
, jackaudioSupport   ? false, libjack2      ? null
}:

with stdenv.lib;

let
  available = x: x != null;
in
assert x11Support         -> all available [libGLU_combined libX11 libXext libXxf86vm libXrandr];
assert waylandSupport     -> all available [wayland wayland-protocols libxkbcommon];
assert rubberbandSupport  -> available rubberband;
assert xineramaSupport    -> x11Support && available libXinerama;
assert xvSupport          -> x11Support && available libXv;
assert sdl2Support        -> available SDL2;
assert alsaSupport        -> available alsaLib;
assert screenSaverSupport -> available libXScrnSaver;
assert cmsSupport         -> available lcms2;
assert vdpauSupport       -> available libvdpau;
assert dvdreadSupport     -> available libdvdread;
assert dvdnavSupport      -> available libdvdnav;
assert bluraySupport      -> available libbluray;
assert speexSupport       -> available speex;
assert theoraSupport      -> available libtheora;
assert openalSupport      -> available openalSoft;
assert pulseSupport       -> available libpulseaudio;
assert bs2bSupport        -> available libbs2b;
assert cacaSupport        -> available libcaca;
assert libpngSupport      -> available libpng;
assert youtubeSupport     -> available youtube-dl;
assert vapoursynthSupport -> available vapoursynth;
assert jackaudioSupport   -> available libjack2;
assert archiveSupport     -> available libarchive;
assert vaapiSupport       -> available libva;
assert drmSupport         -> available libdrm;

let
  # Purity: Waf is normally downloaded by bootstrap.py, but
  # for purity reasons this behavior should be avoided.
  wafVersion = "2.0.9";
  waf = fetchurl {
    urls = [ "https://waf.io/waf-${wafVersion}"
             "http://www.freehackers.org/~tnagy/release/waf-${wafVersion}" ];
    sha256 = "0j7sbn3w6bgslvwwh5v9527w3gi2sd08kskrgxamx693y0b0i3ia";
  };
in stdenv.mkDerivation rec {
  name = "mpv-${version}";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "mpv-player";
    repo  = "mpv";
    rev    = "v${version}";
    sha256 = "0i2nl65diqsjyz28dj07h6d8gq6ix72ysfm0nhs8514hqccaihs3";
  };

  # FIXME: Remove this patch for building on macOS if it gets released in
  # the future.
  patches = optional stdenv.isDarwin (fetchpatch {
    url = https://github.com/mpv-player/mpv/commit/dc553c8cf4349b2ab5d2a373ad2fac8bdd229ebb.patch;
    sha256 = "0pa8vlb8rsxvd1s39c4iv7gbaqlkn3hx21a6xnpij99jdjkw3pg8";
  });

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
    (enableFeature archiveSupport "libarchive")
    (enableFeature dvdreadSupport "dvdread")
    (enableFeature dvdnavSupport "dvdnav")
    (enableFeature openalSupport "openal")
    (enableFeature vaapiSupport "vaapi")
    (enableFeature waylandSupport "wayland")
    (enableFeature stdenv.isLinux "dvbin")
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
    lua luasocket libuchardet
  ] ++ optional alsaSupport        alsaLib
    ++ optional xvSupport          libXv
    ++ optional theoraSupport      libtheora
    ++ optional xineramaSupport    libXinerama
    ++ optional dvdreadSupport     libdvdread
    ++ optional bluraySupport      libbluray
    ++ optional jackaudioSupport   libjack2
    ++ optional pulseSupport       libpulseaudio
    ++ optional rubberbandSupport  rubberband
    ++ optional screenSaverSupport libXScrnSaver
    ++ optional cmsSupport        lcms2
    ++ optional vdpauSupport       libvdpau
    ++ optional speexSupport       speex
    ++ optional bs2bSupport        libbs2b
    ++ optional openalSupport      openalSoft
    ++ optional libpngSupport      libpng
    ++ optional youtubeSupport     youtube-dl
    ++ optional sdl2Support        SDL2
    ++ optional cacaSupport        libcaca
    ++ optional vaapiSupport       libva
    ++ optional drmSupport         libdrm
    ++ optional vapoursynthSupport vapoursynth
    ++ optional archiveSupport     libarchive
    ++ optional stdenv.isDarwin    libiconv
    ++ optionals dvdnavSupport     [ libdvdnav libdvdnav.libdvdread ]
    ++ optionals x11Support        [ libX11 libXext libGLU_combined libXxf86vm libXrandr ]
    ++ optionals waylandSupport    [ wayland wayland-protocols libxkbcommon ]
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
  let
    getPath  = type : "${luasocket}/lib/lua/${lua.luaversion}/?.${type};" +
                      "${luasocket}/share/lua/${lua.luaversion}/?.${type}";
    luaPath  = getPath "lua";
    luaCPath = getPath "so";
  in
  ''
      --prefix LUA_PATH : "${luaPath}" \
      --prefix LUA_CPATH : "${luaCPath}" \
  '' + optionalString youtubeSupport ''
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
