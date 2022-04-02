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
, nv-codec-headers
, lua
, libuchardet
, libiconv
, CoreFoundation, Cocoa, CoreAudio, MediaPlayer

, waylandSupport ? stdenv.isLinux
  , wayland
  , wayland-protocols
  , libxkbcommon

, x11Support ? stdenv.isLinux
  , libGLU, libGL
  , libX11
  , libXext
  , libXxf86vm
  , libXrandr

, cddaSupport ? false
  , libcdio
  , libcdio-paranoia

, vulkanSupport ? stdenv.isLinux
  , libplacebo
  , shaderc
  , vulkan-headers
  , vulkan-loader

, drmSupport ? stdenv.isLinux
  , libdrm
  , mesa

, alsaSupport        ? stdenv.isLinux, alsa-lib
, archiveSupport     ? true,           libarchive
, bluraySupport      ? true,           libbluray
, bs2bSupport        ? true,           libbs2b
, cacaSupport        ? true,           libcaca
, cmsSupport         ? true,           lcms2
, dvdnavSupport      ? stdenv.isLinux, libdvdnav
, jackaudioSupport   ? false,          libjack2
, javascriptSupport  ? true,           mujs
, libpngSupport      ? true,           libpng
, openalSupport      ? true,           openalSoft
, pulseSupport       ? config.pulseaudio or stdenv.isLinux, libpulseaudio
, rubberbandSupport  ? stdenv.isLinux, rubberband
, screenSaverSupport ? true,           libXScrnSaver
, sdl2Support        ? true,           SDL2
, sixelSupport       ? false,          libsixel
, speexSupport       ? true,           speex
, swiftSupport       ? false,          swift
, theoraSupport      ? true,           libtheora
, vaapiSupport       ? stdenv.isLinux, libva
, vapoursynthSupport ? false,          vapoursynth
, vdpauSupport       ? true,           libvdpau
, xineramaSupport    ? stdenv.isLinux, libXinerama
, xvSupport          ? stdenv.isLinux, libXv
, zimgSupport        ? true,           zimg
}:

with lib;

let
  luaEnv = lua.withPackages (ps: with ps; [ luasocket ]);

in stdenv.mkDerivation rec {
  pname = "mpv";
  version = "0.34.1";

  outputs = [ "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "mpv-player";
    repo = "mpv";
    rev = "v${version}";
    sha256 = "12qxwm1ww5vhjddl8yvj1xa0n1fi9z3lmzwhaiday2v59ca0qgsk";
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
    (lib.enableFeature javascriptSupport "javascript")
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
    ++ lib.optionals javascriptSupport  [ mujs ]
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
}
