{ config
, lib
, stdenv
, fetchFromGitHub
, fetchpatch
, addOpenGLRunpath
, docutils
, perl
, pkg-config
, python3
, wafHook
, which
, ffmpeg
, freefont_ttf
, freetype
, libass
, libpthreadstubs
, mujs
, nv-codec-headers
, lua
, libuchardet
, libiconv ? null
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

, alsaSupport        ? stdenv.isLinux, alsa-lib      ? null
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
  version = "0.34.0";

  outputs = [ "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "mpv-player";
    repo = "mpv";
    rev = "v${version}";
    sha256 = "sha256-qa6xZV4aLcHBMa2bIqoKjte4+KWEGGZre4L0u1+eDE8=";
  };

  postPatch = ''
    patchShebangs ./TOOLS/
  '';
  NIX_LDFLAGS = lib.optionalString x11Support "-lX11 -lXext "
              + lib.optionalString stdenv.isDarwin "-framework CoreFoundation";

  wafConfigureFlags = [
    "--enable-libmpv-shared"
    "--enable-manpage-build"
    "--disable-libmpv-static"
    "--disable-static-build"
    "--disable-build-date" # Purity
    (lib.enableFeature archiveSupport  "libarchive")
    (lib.enableFeature cddaSupport     "cdda")
    (lib.enableFeature dvdnavSupport   "dvdnav")
    (lib.enableFeature openalSupport   "openal")
    (lib.enableFeature sdl2Support     "sdl2")
    (lib.enableFeature sixelSupport    "sixel")
    (lib.enableFeature vaapiSupport    "vaapi")
    (lib.enableFeature waylandSupport  "wayland")
    (lib.enableFeature stdenv.isLinux  "dvbin")
  ] # Disable whilst Swift isn't supported
    ++ lib.optional (!swiftSupport) "--disable-macos-cocoa-cb";

  nativeBuildInputs = [
    addOpenGLRunpath
    docutils
    perl
    pkg-config
    python3
    wafHook
    which
  ] ++ lib.optionals swiftSupport [ swift ];

  buildInputs = [
    ffmpeg
    freetype
    libass
    libpthreadstubs
    libuchardet
    luaEnv
    mujs
  ] ++ lib.optionals alsaSupport        [ alsa-lib ]
    ++ lib.optionals archiveSupport     [ libarchive ]
    ++ lib.optionals bluraySupport      [ libbluray ]
    ++ lib.optionals bs2bSupport        [ libbs2b ]
    ++ lib.optionals cacaSupport        [ libcaca ]
    ++ lib.optionals cddaSupport        [ libcdio libcdio-paranoia ]
    ++ lib.optionals cmsSupport         [ lcms2 ]
    ++ lib.optionals drmSupport         [ libdrm mesa ]
    ++ lib.optionals dvdnavSupport      [ libdvdnav libdvdnav.libdvdread ]
    ++ lib.optionals jackaudioSupport   [ libjack2 ]
    ++ lib.optionals libpngSupport      [ libpng ]
    ++ lib.optionals openalSupport      [ openalSoft ]
    ++ lib.optionals pulseSupport       [ libpulseaudio ]
    ++ lib.optionals rubberbandSupport  [ rubberband ]
    ++ lib.optionals screenSaverSupport [ libXScrnSaver ]
    ++ lib.optionals sdl2Support        [ SDL2 ]
    ++ lib.optionals sixelSupport       [ libsixel ]
    ++ lib.optionals speexSupport       [ speex ]
    ++ lib.optionals theoraSupport      [ libtheora ]
    ++ lib.optionals vaapiSupport       [ libva ]
    ++ lib.optionals vapoursynthSupport [ vapoursynth ]
    ++ lib.optionals vdpauSupport       [ libvdpau ]
    ++ lib.optionals vulkanSupport      [ libplacebo shaderc vulkan-headers vulkan-loader ]
    ++ lib.optionals waylandSupport     [ wayland wayland-protocols libxkbcommon ]
    ++ lib.optionals x11Support         [ libX11 libXext libGLU libGL libXxf86vm libXrandr ]
    ++ lib.optionals xineramaSupport    [ libXinerama ]
    ++ lib.optionals xvSupport          [ libXv ]
    ++ lib.optionals zimgSupport        [ zimg ]
    ++ lib.optionals stdenv.isLinux     [ nv-codec-headers ]
    ++ lib.optionals stdenv.isDarwin    [ libiconv ]
    ++ lib.optionals stdenv.isDarwin    [ CoreFoundation Cocoa CoreAudio MediaPlayer ];

  enableParallelBuilding = true;

  postBuild = lib.optionalString stdenv.isDarwin ''
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
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -r build/mpv.app $out/Applications
  '';

  # Set RUNPATH so that libcuda in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addOpenGLRunpath.
  postFixup = lib.optionalString stdenv.isLinux ''
    addOpenGLRunpath $out/bin/mpv
  '';

  meta = with lib; {
    homepage = "https://mpv.io";
    description = "General-purpose media player, fork of MPlayer and mplayer2";
    longDescription = ''
      mpv is a free and open-source general-purpose video player, based on the
      MPlayer and mplayer2 projects, with great improvements above both.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres fpletz globin ma27 tadeokondrak ];
    platforms = platforms.darwin ++ platforms.linux;
  };

  passthru = {
    inherit
    # The wrapper consults luaEnv and lua.version
    luaEnv
    lua
    # In the wrapper, we want to reference vapoursynth which has the `python3`
    # passthru attribute (which has the `sitePrefix` attribute). This way we'll
    # be sure that in the wrapper we'll use the same python3.sitePrefix used to
    # build vapoursynth.
    vapoursynthSupport
    vapoursynth
    ;
  };
}
