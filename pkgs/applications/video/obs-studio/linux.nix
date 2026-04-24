{
  config,
  lib,
  stdenv,
  nv-codec-headers-12,
  addDriverRunpath,
  autoAddDriverRunpath,
  cudaSupport ? config.cudaSupport,
  fdk_aac,
  libxkbcommon,
  libpthread-stubs,
  libxdmcp,
  libv4l,
  wayland,
  libx11,
  libvlc,
  libGL,
  wrapGAppsHook3,
  scriptingSupport ? true,
  luajit,
  python3,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  pulseaudioSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  libpulseaudio,
  browserSupport ? true,
  pciutils,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
  withFdk ? true,
  pipewire,
  libdrm,
  libva,
  srt,
  qtwayland,
  decklinkSupport ? false,
  blackmagic-desktop-video,
  libvpl,
  extra-cmake-modules,
  mkObsCefPackage,
}:

let
  inherit (lib) optional optionals;

  cef = mkObsCefPackage {
    version = "6533";
    revision = "6";
    platformMap = {
      aarch64-linux = "linux_aarch64";
      x86_64-linux = "linux_x86_64";
    };
    hashes = {
      aarch64-linux = "sha256-ZCUURp6qKaXIh4kQhNLnP33C10Bfffp3JrLbwkswmZk=";
      x86_64-linux = "sha256-eWMzVRmhnM3FIz9zNMWrAjAm4vPpoMxBcAfAnYZggUY=";
    };
  };
in
{
  preset = "nixpkgs-linux";

  separateDebugInfo = true;

  patches = [
    ./fix-nix-plugin-path.patch
  ];

  extraNativeBuildInputs = [
    addDriverRunpath
    wrapGAppsHook3
    extra-cmake-modules
  ]
  ++ optional cudaSupport autoAddDriverRunpath;

  extraBuildInputs = [
    libGL
    libv4l
    libvlc
    libxkbcommon
    libpthread-stubs
    libxdmcp
    libvpl
    libva
    nv-codec-headers-12
    pciutils
    qtwayland
    srt
    wayland
  ]
  ++ optional browserSupport cef
  ++ optionals scriptingSupport [
    luajit
    python3
  ]
  ++ optional alsaSupport alsa-lib
  ++ optional pulseaudioSupport libpulseaudio
  ++ optionals pipewireSupport [
    pipewire
    libdrm
  ]
  ++ optional withFdk fdk_aac;

  cmakeFlags = [
    "-DENABLE_JACK=ON"
    (lib.cmakeBool "ENABLE_QSV11" stdenv.hostPlatform.isx86_64)
    (lib.cmakeBool "ENABLE_LIBFDK" withFdk)
    (lib.cmakeBool "ENABLE_ALSA" alsaSupport)
    (lib.cmakeBool "ENABLE_PULSEAUDIO" pulseaudioSupport)
    (lib.cmakeBool "ENABLE_PIPEWIRE" pipewireSupport)
    (lib.cmakeBool "ENABLE_AJA" false) # TODO: fix linking against libajantv2
  ];

  nixCflagsCompile = [
    "-Wno-error=sign-compare" # https://github.com/obsproject/obs-studio/issues/10200
    "-Wno-error=stringop-overflow="
  ];

  dontWrapGApps = true;
  preFixup =
    let
      wrapperLibraries = [
        libx11
        libvlc
        libGL
      ]
      ++ optionals decklinkSupport [ blackmagic-desktop-video ];
    in
    ''
      qtWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "$out/lib:${lib.makeLibraryPath wrapperLibraries}"
        ''${gappsWrapperArgs[@]}
      )
    ''
    + lib.optionalString browserSupport ''
      # Remove cef components before patchelf, otherwise it will fail
      rm $out/lib/obs-plugins/libcef.so
      rm $out/lib/obs-plugins/libEGL.so
      rm $out/lib/obs-plugins/libGLESv2.so
      rm $out/lib/obs-plugins/libvk_swiftshader.so
      rm $out/lib/obs-plugins/libvulkan.so.1
      rm $out/lib/obs-plugins/chrome-sandbox
    '';

  postFixup = lib.concatStrings [
    (lib.optionalString stdenv.hostPlatform.isLinux ''
      addDriverRunpath $out/lib/lib*.so
      addDriverRunpath $out/lib/obs-plugins/*.so
    '')

    (lib.optionalString browserSupport ''
      # Link cef components again after patchelfing other libs
      ln -sf ${cef}/${cef.buildType}/* $out/lib/obs-plugins/
    '')
  ];

  meta = {
    maintainers = with lib.maintainers; [
      jb55
      materus
      fpletz
    ];
    license = with lib.licenses; [ gpl2Plus ] ++ optional withFdk fraunhofer-fdk;
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];
  };
}
