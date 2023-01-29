{ config
, lib
, stdenv
, fetchFromGitHub
, addOpenGLRunpath
, docutils
, meson
, ninja
, pkg-config
, python3
, ffmpeg_5
, freefont_ttf
, freetype
, libass
, libpthreadstubs
, nv-codec-headers
, lua
, libuchardet
, libiconv
, xcbuild

, waylandSupport ? stdenv.isLinux
  , wayland
  , wayland-protocols
  , wayland-scanner
  , libxkbcommon

, x11Support ? stdenv.isLinux
  , libGLU, libGL
  , libX11
  , libXext
  , libXxf86vm
  , libXrandr
  , libXpresent

, cddaSupport ? false
  , libcdio
  , libcdio-paranoia

, vulkanSupport ? stdenv.isLinux
  , libplacebo
  , shaderc # instead of spirv-cross
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
, dvbinSupport       ? stdenv.isLinux
, jackaudioSupport   ? false,          libjack2
, javascriptSupport  ? true,           mujs
, libpngSupport      ? true,           libpng
, openalSupport      ? true,           openalSoft
, pulseSupport       ? config.pulseaudio or stdenv.isLinux, libpulseaudio
, pipewireSupport    ? stdenv.isLinux, pipewire
, rubberbandSupport  ? true,           rubberband
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
, darwin
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreFoundation Cocoa CoreAudio MediaPlayer;
  luaEnv = lua.withPackages (ps: with ps; [ luasocket ]);
in stdenv.mkDerivation (self: {
  pname = "mpv";
  version = "0.35.1";

  outputs = [ "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "mpv-player";
    repo = "mpv";
    rev = "v${self.version}";
    sha256 = "sha256-CoYTX9hgxLo72YdMoa0sEywg4kybHbFsypHk1rCM6tM=";
  };

  postPatch = ''
    patchShebangs version.* ./TOOLS/
  '';

  NIX_LDFLAGS = lib.optionalString x11Support "-lX11 -lXext ";

  mesonFlags = [
    (lib.mesonOption "default_library" "shared")
    (lib.mesonBool "libmpv" true)
    (lib.mesonEnable "libarchive" archiveSupport)
    (lib.mesonEnable "manpage-build" true)
    (lib.mesonEnable "cdda" cddaSupport)
    (lib.mesonEnable "dvbin" dvbinSupport)
    (lib.mesonEnable "dvdnav" dvdnavSupport)
    (lib.mesonEnable "openal" openalSupport)
    (lib.mesonEnable "sdl2" sdl2Support)
    # Disable whilst Swift isn't supported
    (lib.mesonEnable "swift-build" swiftSupport)
    (lib.mesonEnable "macos-cocoa-cb" swiftSupport)
  ];

  mesonAutoFeatures = "auto";

  nativeBuildInputs = [
    addOpenGLRunpath
    docutils # for rst2man
    meson
    ninja
    pkg-config
    python3
  ]
  ++ lib.optionals stdenv.isDarwin [ xcbuild.xcrun ]
  ++ lib.optionals swiftSupport [ swift ]
  ++ lib.optionals waylandSupport [ wayland-scanner ];

  buildInputs = [
    ffmpeg_5
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
    ++ lib.optionals pipewireSupport    [ pipewire ]
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
    ++ lib.optionals x11Support         [ libX11 libXext libGLU libGL libXxf86vm libXrandr libXpresent ]
    ++ lib.optionals xineramaSupport    [ libXinerama ]
    ++ lib.optionals xvSupport          [ libXv ]
    ++ lib.optionals zimgSupport        [ zimg ]
    ++ lib.optionals stdenv.isLinux     [ nv-codec-headers ]
    ++ lib.optionals stdenv.isDarwin    [ libiconv ]
    ++ lib.optionals stdenv.isDarwin    [ CoreFoundation Cocoa CoreAudio MediaPlayer ];

  postBuild = lib.optionalString stdenv.isDarwin ''
    pushd .. # Must be run from the source dir because it uses relative paths
    python3 TOOLS/osxbundle.py -s build/mpv
    popd
  '';

  postInstall = ''
    # Use a standard font
    mkdir -p $out/share/mpv
    ln -s ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mpv/subfont.ttf

    cp ../TOOLS/mpv_identify.sh $out/bin
    cp ../TOOLS/umpv $out/bin
    cp $out/share/applications/mpv.desktop $out/share/applications/umpv.desktop
    sed -i '/Icon=/ ! s/mpv/umpv/g' $out/share/applications/umpv.desktop
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -r mpv.app $out/Applications
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
    changelog = "https://github.com/mpv-player/mpv/releases/tag/v${self.version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres fpletz globin ma27 tadeokondrak ];
    platforms = platforms.unix;
  };
})
