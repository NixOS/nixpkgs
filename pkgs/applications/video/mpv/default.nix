{ lib
, buildPackages
, config
, stdenv
, fetchFromGitHub
, addOpenGLRunpath
, bash
, docutils
, meson
, ninja
, pkg-config
, python3
, ffmpeg
, freefont_ttf
, freetype
, libass
, libpthreadstubs
, nv-codec-headers-11
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
, swiftSupport       ? stdenv.isDarwin, swift
, theoraSupport      ? true,           libtheora
, vaapiSupport       ? x11Support || waylandSupport, libva
, vapoursynthSupport ? false,          vapoursynth
, vdpauSupport       ? true,           libvdpau
, xineramaSupport    ? stdenv.isLinux, libXinerama
, xvSupport          ? stdenv.isLinux, libXv
, zimgSupport        ? true,           zimg
, darwin
}:

let
  inherit (darwin.apple_sdk_11_0.frameworks)
    AVFoundation Accelerate Cocoa CoreAudio CoreFoundation CoreMedia
    MediaPlayer VideoToolbox;
  luaEnv = lua.withPackages (ps: with ps; [ luasocket ]);

  overrideSDK = platform: version:
    platform // lib.optionalAttrs (platform ? darwinMinVersion) {
      darwinMinVersion = version;
    };

  stdenv' = if swiftSupport && stdenv.isDarwin && stdenv.isx86_64
    then stdenv.override (old: {
      buildPlatform = overrideSDK old.buildPlatform "10.15";
      hostPlatform = overrideSDK old.hostPlatform "10.15";
      targetPlatform = overrideSDK old.targetPlatform "10.15";
    })
    else stdenv;
in stdenv'.mkDerivation (finalAttrs: {
  pname = "mpv";
  version = "0.38.0";

  outputs = [ "out" "dev" "doc" "man" ];

  src = fetchFromGitHub {
    owner = "mpv-player";
    repo = "mpv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dFajnCpGlNqUv33A8eFEn8kjtzIPkcBY5j0gNVlaiIY=";
  };

  postPatch = lib.concatStringsSep "\n" [
    # Don't reference compile time dependencies or create a build outputs cycle
    # between out and dev
    ''
    substituteInPlace meson.build \
      --replace-fail "conf_data.set_quoted('CONFIGURATION', configuration)" \
                     "conf_data.set_quoted('CONFIGURATION', '<ommited>')"
    ''
    # A trick to patchShebang everything except mpv_identify.sh
    ''
    pushd TOOLS
    mv mpv_identify.sh mpv_identify
    patchShebangs *.py *.sh
    mv mpv_identify mpv_identify.sh
    popd
    ''
  ];

  # Ensure we reference 'lib' (not 'out') of Swift.
  preConfigure = lib.optionalString swiftSupport ''
    export SWIFT_LIB_DYNAMIC="${lib.getLib swift.swift}/lib/swift/macosx"
  '';

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
  ] ++ lib.optionals stdenv.isDarwin [
    # Toggle explicitly because it fails on darwin
    (lib.mesonEnable "videotoolbox-pl" vulkanSupport)
  ];

  mesonAutoFeatures = "auto";

  nativeBuildInputs = [
    addOpenGLRunpath
    docutils # for rst2man
    meson
    ninja
    pkg-config
  ]
  ++ lib.optionals stdenv.isDarwin [ buildPackages.darwin.sigtool xcbuild.xcrun ]
  ++ lib.optionals swiftSupport [ swift ]
  ++ lib.optionals waylandSupport [ wayland-scanner ];

  buildInputs = [
    bash
    ffmpeg
    freetype
    libass
    libplacebo
    libpthreadstubs
    libuchardet
    luaEnv
    python3
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
    ++ lib.optionals vulkanSupport      [ shaderc vulkan-headers vulkan-loader ]
    ++ lib.optionals waylandSupport     [ wayland wayland-protocols libxkbcommon ]
    ++ lib.optionals x11Support         [ libX11 libXext libGLU libGL libXxf86vm libXrandr libXpresent ]
    ++ lib.optionals xineramaSupport    [ libXinerama ]
    ++ lib.optionals xvSupport          [ libXv ]
    ++ lib.optionals zimgSupport        [ zimg ]
    ++ lib.optionals stdenv.isLinux     [ nv-codec-headers-11 ]
    ++ lib.optionals stdenv.isDarwin    [ libiconv ]
    ++ lib.optionals stdenv.isDarwin    [ Accelerate CoreFoundation Cocoa CoreAudio MediaPlayer VideoToolbox ]
    ++ lib.optionals (stdenv.isDarwin && swiftSupport) [ AVFoundation CoreMedia ];

  postBuild = lib.optionalString stdenv.isDarwin ''
    pushd .. # Must be run from the source dir because it uses relative paths
    python3 TOOLS/osxbundle.py -s build/mpv
    popd
  '';

  postInstall = ''
    # Use a standard font
    mkdir -p $out/share/mpv
    ln -s ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mpv/subfont.ttf

    pushd ../TOOLS
    cp mpv_identify.sh umpv $out/bin/
    popd
    pushd $out/share/applications

    # patch out smb protocol reference, since our ffmpeg can't handle it
    substituteInPlace mpv.desktop --replace-fail "smb," ""

    sed -e '/Icon=/ ! s|mpv|umpv|g; s|^Exec=.*|Exec=umpv %U|' \
      mpv.desktop > umpv.desktop
    printf "NoDisplay=true\n" >> umpv.desktop
    popd
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -r mpv.app $out/Applications
  '';

  # Set RUNPATH so that libcuda in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addOpenGLRunpath.
  postFixup = lib.optionalString stdenv.isLinux ''
    addOpenGLRunpath $out/bin/mpv
    patchShebangs --update --host $out/bin/umpv $out/bin/mpv_identify.sh
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

  meta = {
    homepage = "https://mpv.io";
    description = "General-purpose media player, fork of MPlayer and mplayer2";
    longDescription = ''
      mpv is a free and open-source general-purpose video player, based on the
      MPlayer and mplayer2 projects, with great improvements above both.
    '';
    changelog = "https://github.com/mpv-player/mpv/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "mpv";
    maintainers = with lib.maintainers; [
      AndersonTorres fpletz globin ma27 tadeokondrak
    ];
    platforms = lib.platforms.unix;
  };
})
