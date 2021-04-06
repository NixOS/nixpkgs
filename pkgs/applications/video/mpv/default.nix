{ config, stdenv, fetchurl, fetchFromGitHub, fetchpatch
, addOpenGLRunpath, docutils, perl, pkgconfig, python3, wafHook, which
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

, alsaSupport        ? stdenv.isLinux, alsaLib       ? null
, bluraySupport      ? true,           libbluray     ? null
, bs2bSupport        ? true,           libbs2b       ? null
, cacaSupport        ? true,           libcaca       ? null
, cmsSupport         ? true,           lcms2         ? null
, dvdnavSupport      ? stdenv.isLinux, libdvdnav     ? null
, libpngSupport      ? true,           libpng        ? null
, pulseSupport       ? config.pulseaudio or stdenv.isLinux, libpulseaudio ? null
, rubberbandSupport  ? stdenv.isLinux, rubberband    ? null
# NOTE: samba support should be removed on the next mpv release, see also:
# https://github.com/NixOS/nixpkgs/pull/89145#issuecomment-636424362
# Please remove this line on the next mpv release.
, sambaSupport       ? false,          samba         ? null
, screenSaverSupport ? true,           libXScrnSaver ? null
, sdl2Support        ? true,           SDL2          ? null
, sndioSupport       ? true,           sndio         ? null
, speexSupport       ? true,           speex         ? null
, swiftSupport       ? false,          swift         ? null
, theoraSupport      ? true,           libtheora     ? null
, vaapiSupport       ? stdenv.isLinux, libva         ? null
, vdpauSupport       ? true,           libvdpau      ? null
, xineramaSupport    ? stdenv.isLinux, libXinerama   ? null
, xvSupport          ? stdenv.isLinux, libXv         ? null
, zimgSupport        ? true,           zimg          ? null
, archiveSupport     ? true,           libarchive    ? null
, jackaudioSupport   ? false,          libjack2      ? null
, openalSupport      ? true,           openalSoft    ? null
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
assert sambaSupport       -> available samba;
assert sdl2Support        -> available SDL2;
assert sndioSupport       -> available sndio;
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
  version = "0.32.0";

  src = fetchFromGitHub {
    owner  = "mpv-player";
    repo   = "mpv";
    rev    = "v${version}";
    sha256 = "0kmy1q0hp87vq4rpv7py04x8bpg1wmlzaibavmkf713jqp6qy596";
  };

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
    (enableFeature sambaSupport    "libsmbclient")
    (enableFeature sdl2Support     "sdl2")
    (enableFeature sndioSupport    "sndio")
    (enableFeature vaapiSupport    "vaapi")
    (enableFeature waylandSupport  "wayland")
    (enableFeature stdenv.isLinux  "dvbin")
  ] # Disable whilst Swift isn't supported
    ++ stdenv.lib.optional (!swiftSupport) "--disable-macos-cocoa-cb";

  nativeBuildInputs = [
    addOpenGLRunpath docutils perl pkgconfig python3 wafHook which
  ]
    ++ optional swiftSupport swift;

  buildInputs = [
    ffmpeg freetype libass libpthreadstubs
    luaEnv libuchardet mujs
  ] ++ optional alsaSupport        alsaLib
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
    ++ optional sambaSupport       samba
    ++ optional screenSaverSupport libXScrnSaver
    ++ optional sdl2Support        SDL2
    ++ optional sndioSupport       sndio
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

  patches = (stdenv.lib.optionals stdenv.isDarwin [
    # Fix cocoa backend. Remove with the next release
    (fetchpatch {
      url = "https://github.com/mpv-player/mpv/commit/188169854313b99d01da8f69fe129f0a487eb7c4.patch";
      sha256 = "062sz4666prb2wg1rn5q8brqkzlq6lxn8sxic78a8lb0125c01f7";
    })
  ]) ++ [
    (fetchpatch {
      url = "https://github.com/mpv-player/mpv/commit/d0c530919d8cd4d7a774e38ab064e0fabdae34e6.patch";
      sha256 = "1cxfdvzxm963kaiign876ypbr1zs762vr5bcww0mc9spgdxzjcx2";
    })];

  postInstall = ''
    # Use a standard font
    mkdir -p $out/share/mpv
    ln -s ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mpv/subfont.ttf

    cp TOOLS/umpv $out/bin
  '' + optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -r build/mpv.app $out/Applications
  '';

  # Set RUNPATH so that libcuda in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addOpenGLRunpath.
  postFixup = optionalString stdenv.isLinux ''
    addOpenGLRunpath $out/bin/mpv
  '';

  meta = with stdenv.lib; {
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
