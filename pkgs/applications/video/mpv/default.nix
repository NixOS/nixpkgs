{ config, lib, stdenv, fetchFromGitHub, fetchpatch
, addOpenGLRunpath, docutils, perl, pkg-config, python3, wafHook, which
, ffmpeg, freefont_ttf, freetype, libass, libpthreadstubs, mujs
, nv-codec-headers, lua, libuchardet, libiconv ? null
, CoreFoundation, Cocoa, CoreAudio, MediaPlayer

, waylandSupport ? stdenv.isLinux
  , wayland           ? null
  , wayland-protocols ? null
  , libxkbcommon      ? null

, x11Support ? stdenv.isLinux
  , libGLU, libGL ? null
  , libX11          ? null
  , libXext         ? null
  , libXxf86vm      ? null
  , libXrandr       ? null

, cddaSupport ? false
  , libcdio          ? null
  , libcdio-paranoia ? null

, vulkanSupport ? stdenv.isLinux
  , libplacebo     ? null
  , shaderc        ? null
  , vulkan-headers ? null
  , vulkan-loader  ? null

, drmSupport ? stdenv.isLinux
  , libdrm ? null
  , mesa   ? null

, alsaSupport        ? stdenv.isLinux, alsa-lib       ? null
, archiveSupport     ? true,           libarchive    ? null
, bluraySupport      ? true,           libbluray     ? null
, bs2bSupport        ? true,           libbs2b       ? null
, cacaSupport        ? true,           libcaca       ? null
, cmsSupport         ? true,           lcms2         ? null
, dvdnavSupport      ? stdenv.isLinux, libdvdnav     ? null
, jackaudioSupport   ? false,          libjack2      ? null
, libpngSupport      ? true,           libpng        ? null
, openalSupport      ? true,           openalSoft    ? null
, pulseSupport       ? config.pulseaudio or stdenv.isLinux, libpulseaudio ? null
, rubberbandSupport  ? stdenv.isLinux, rubberband    ? null
, screenSaverSupport ? true,           libXScrnSaver ? null
, sdl2Support        ? true,           SDL2          ? null
, sixelSupport       ? false,          libsixel      ? null
, speexSupport       ? true,           speex         ? null
, swiftSupport       ? false,          swift         ? null
, theoraSupport      ? true,           libtheora     ? null
, vaapiSupport       ? stdenv.isLinux, libva         ? null
, vapoursynthSupport ? false,          vapoursynth   ? null
, vdpauSupport       ? true,           libvdpau      ? null
, xineramaSupport    ? stdenv.isLinux, libXinerama   ? null
, xvSupport          ? stdenv.isLinux, libXv         ? null
, zimgSupport        ? true,           zimg          ? null
}:

with lib;

let
  available = x: x != null;
in
assert alsaSupport        -> available alsa-lib;
assert archiveSupport     -> available libarchive;
assert bluraySupport      -> available libbluray;
assert bs2bSupport        -> available libbs2b;
assert cacaSupport        -> available libcaca;
assert cddaSupport        -> all available [ libcdio libcdio-paranoia ];
assert cmsSupport         -> available lcms2;
assert drmSupport         -> all available [ libdrm mesa ];
assert dvdnavSupport      -> available libdvdnav;
assert jackaudioSupport   -> available libjack2;
assert libpngSupport      -> available libpng;
assert openalSupport      -> available openalSoft;
assert pulseSupport       -> available libpulseaudio;
assert rubberbandSupport  -> available rubberband;
assert screenSaverSupport -> available libXScrnSaver;
assert sdl2Support        -> available SDL2;
assert sixelSupport       -> available libsixel;
assert speexSupport       -> available speex;
assert theoraSupport      -> available libtheora;
assert vaapiSupport       -> available libva;
assert vapoursynthSupport -> available vapoursynth;
assert vdpauSupport       -> available libvdpau;
assert vulkanSupport      -> all available [ libplacebo shaderc vulkan-headers vulkan-loader ];
assert waylandSupport     -> all available [ wayland wayland-protocols libxkbcommon ];
assert x11Support         -> all available [ libGLU libGL libX11 libXext libXxf86vm libXrandr ];
assert xineramaSupport    -> x11Support && available libXinerama;
assert xvSupport          -> x11Support && available libXv;
assert zimgSupport        -> available zimg;

let
  luaEnv = lua.withPackages (ps: with ps; [ luasocket ]);

in stdenv.mkDerivation rec {
  pname = "mpv";
  version = "0.33.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner  = "mpv-player";
    repo   = "mpv";
    rev    = "v${version}";
    sha256 = "06rw1f55zcsj78ql8w70j9ljp2qb1pv594xj7q9cmq7i92a7hq45";
  };

  patches = [
    # To make mpv build with libplacebo 3.104.0:
    (fetchpatch { # vo_gpu: placebo: update for upstream API changes
      url = "https://github.com/mpv-player/mpv/commit/7c4465cefb27d4e0d07535d368febdf77b579566.patch";
      sha256 = "1yfc6220ak5kc5kf7zklmsa944nr9q0qaa27l507pgrmvcyiyzrx";
    })
    # TOREMOVE when > 0.33.1
    # youtube-dl has been abandonned and is now unusable w/
    # youtube.com. Mpv migrated to yt-dlp since the 0.33.1 but did not
    # cut a new release yet. See
    # https://github.com/mpv-player/mpv/pull/9209
    (fetchpatch {
      url = "https://github.com/mpv-player/mpv/commit/d1c92bfd79ef81ac804fcc20aee2ed24e8d587aa.patch";
      sha256 = "1dwxzng3gsrx0gjljm5jmfcjz3pzdss9z2l0n25rmmb4nbcrcx1f";
    })
  ];

  postPatch = ''
    patchShebangs ./TOOLS/
  '';

  passthru = {
    inherit
    # The wrapper consults luaEnv and lua.version
    luaEnv
    lua
    # In the wrapper, we want to reference vapoursynth which has the
    # `python3` passthru attribute (which has the `sitePrefix`
    # attribute). This way we'll be sure that in the wrapper we'll
    # use the same python3.sitePrefix used to build vapoursynth.
    vapoursynthSupport
    vapoursynth
    ;
  };

  NIX_LDFLAGS = optionalString x11Support "-lX11 -lXext "
              + optionalString stdenv.isDarwin "-framework CoreFoundation";

  wafConfigureFlags = [
    "--enable-libmpv-shared"
    "--enable-manpage-build"
    "--disable-libmpv-static"
    "--disable-static-build"
    "--disable-build-date" # Purity
    (enableFeature archiveSupport  "libarchive")
    (enableFeature cddaSupport     "cdda")
    (enableFeature dvdnavSupport   "dvdnav")
    (enableFeature openalSupport   "openal")
    (enableFeature sdl2Support     "sdl2")
    (enableFeature sixelSupport    "sixel")
    (enableFeature vaapiSupport    "vaapi")
    (enableFeature waylandSupport  "wayland")
    (enableFeature stdenv.isLinux  "dvbin")
  ] # Disable whilst Swift isn't supported
    ++ lib.optional (!swiftSupport) "--disable-macos-cocoa-cb";

  nativeBuildInputs = [
    addOpenGLRunpath docutils perl pkg-config python3 wafHook which
  ] ++ optional swiftSupport swift;

  buildInputs = [
    ffmpeg freetype libass libpthreadstubs
    luaEnv libuchardet mujs
  ] ++ optional alsaSupport        alsa-lib
    ++ optional archiveSupport     libarchive
    ++ optional bluraySupport      libbluray
    ++ optional bs2bSupport        libbs2b
    ++ optional cacaSupport        libcaca
    ++ optional cmsSupport         lcms2
    ++ optional jackaudioSupport   libjack2
    ++ optional libpngSupport      libpng
    ++ optional openalSupport      openalSoft
    ++ optional pulseSupport       libpulseaudio
    ++ optional rubberbandSupport  rubberband
    ++ optional screenSaverSupport libXScrnSaver
    ++ optional sdl2Support        SDL2
    ++ optional sixelSupport       libsixel
    ++ optional speexSupport       speex
    ++ optional theoraSupport      libtheora
    ++ optional vaapiSupport       libva
    ++ optional vapoursynthSupport vapoursynth
    ++ optional vdpauSupport       libvdpau
    ++ optional xineramaSupport    libXinerama
    ++ optional xvSupport          libXv
    ++ optional zimgSupport        zimg
    ++ optional stdenv.isDarwin    libiconv
    ++ optional stdenv.isLinux     nv-codec-headers
    ++ optionals cddaSupport       [ libcdio libcdio-paranoia ]
    ++ optionals drmSupport        [ libdrm mesa ]
    ++ optionals dvdnavSupport     [ libdvdnav libdvdnav.libdvdread ]
    ++ optionals waylandSupport    [ wayland wayland-protocols libxkbcommon ]
    ++ optionals x11Support        [ libX11 libXext libGLU libGL libXxf86vm libXrandr ]
    ++ optionals vulkanSupport     [ libplacebo shaderc vulkan-headers vulkan-loader ]
    ++ optionals stdenv.isDarwin   [ CoreFoundation Cocoa CoreAudio MediaPlayer ];

  enableParallelBuilding = true;

  postBuild = optionalString stdenv.isDarwin ''
    python3 TOOLS/osxbundle.py -s build/mpv
  '';

  postInstall = ''
    # Use a standard font
    mkdir -p $out/share/mpv
    ln -s ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mpv/subfont.ttf

    cp TOOLS/mpv_identify.sh $out/bin
    cp TOOLS/umpv $out/bin
    cp $out/share/applications/mpv.desktop $out/share/applications/umpv.desktop
    sed -i '/Icon=/ ! s/mpv/umpv/g' $out/share/applications/umpv.desktop

    substituteInPlace $out/lib/pkgconfig/mpv.pc \
      --replace "$out/include" "$dev/include"
  '' + optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -r build/mpv.app $out/Applications
  '';

  # Set RUNPATH so that libcuda in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addOpenGLRunpath.
  postFixup = optionalString stdenv.isLinux ''
    addOpenGLRunpath $out/bin/mpv
  '';

  meta = with lib; {
    description = "A media player that supports many video formats (MPlayer and mplayer2 fork)";
    homepage = "https://mpv.io";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres fpletz globin ma27 tadeokondrak ];
    platforms = platforms.darwin ++ platforms.linux;

    longDescription = ''
      mpv is a free and open-source general-purpose video player,
      based on the MPlayer and mplayer2 projects, with great
      improvements above both.
    '';
  };
}
