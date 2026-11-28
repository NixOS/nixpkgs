{
  config,
  uthash,
  lib,
  stdenv,
  ninja,
  nv-codec-headers-12,
  fetchFromGitHub,
  fetchurl,
  addDriverRunpath,
  autoAddDriverRunpath,
  cudaSupport ? config.cudaSupport,
  cmake,
  fdk_aac,
  ffmpeg,
  jansson,
  libjack2,
  libxkbcommon,
  libpthread-stubs,
  libxdmcp,
  qt6,
  speex,
  libv4l,
  x264,
  curl,
  wayland,
  libx11,
  pkg-config,
  libvlc,
  libGL,
  mbedtls,
  wrapGAppsHook3,
  scriptingSupport ? true,
  luajit,
  swig,
  python3,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  pulseaudioSupport ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  browserSupport ? true,
  cef-binary,
  pciutils,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
  withFdk ? true,
  pipewire,
  libdrm,
  librist,
  cjson,
  libva,
  srt,
  nlohmann_json,
  websocketpp,
  asio,
  decklinkSupport ? false,
  blackmagic-desktop-video,
  libdatachannel,
  libvpl,
  qrcodegencpp,
  simde,
  nix-update-script,
  kdePackages,
}:

let
  inherit (lib) optional optionals;

  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");

  cef = cef-binary.overrideAttrs (
    oldAttrs:
    let
      version = "7871";
      revision = "2";
    in
    {
      inherit version;

      src = fetchurl {
        url = "https://cdn-fastly.obsproject.com/downloads/cef_binary_${version}_linux_${
          selectSystem {
            aarch64-linux = "aarch64";
            x86_64-linux = "x86_64";
          }
        }_v${revision}.tar.xz";
        hash = selectSystem {
          aarch64-linux = "sha256-pvBOpaGgVV1oPy2vpmPgcEoOqVTXA97kyrX/Z7oHStA=";
          x86_64-linux = "sha256-P1x0+MTEsk276f9M/3unZKpNCnISe5aXY0LkNg5DXbM=";
        };
      };
    }
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "obs-studio";
  version = "33.0.3";

  src = fetchFromGitHub {
    owner = "obsproject";
    repo = "obs-studio";
    tag = finalAttrs.version;
    hash = "sha256-171bpL3Mn/3RFqu1ATE+3u8xoVHqhCPQYM9HdqWv5OY=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  nativeBuildInputs = [
    addDriverRunpath
    cmake
    ninja
    pkg-config
    wrapGAppsHook3
    qt6.wrapQtAppsHook
    kdePackages.extra-cmake-modules
  ]
  ++ optional scriptingSupport swig
  ++ optional cudaSupport autoAddDriverRunpath;

  buildInputs = [
    curl
    ffmpeg
    jansson
    libjack2
    libv4l
    libxkbcommon
    libpthread-stubs
    libxdmcp
    qt6.qtbase
    qt6.qtsvg
    speex
    wayland
    x264
    libvlc
    mbedtls
    pciutils
    librist
    cjson
    libva
    srt
    qt6.qtwayland
    nlohmann_json
    websocketpp
    asio
    libdatachannel
    libvpl
    qrcodegencpp
    uthash
    nv-codec-headers-12
  ]
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
  ++ optional browserSupport cef
  ++ optional withFdk fdk_aac;

  propagatedBuildInputs = [ simde ];

  postPatch = ''
    cp ${./CMakeUserPresets.json} ./CMakeUserPresets.json
  '';

  cmakeFlags = [
    "--preset"
    "nixpkgs-${if stdenv.hostPlatform.isDarwin then "darwin" else "linux"}"
    (lib.cmakeFeature "OBS_VERSION_OVERRIDE" finalAttrs.version)
    # Module search paths are built from it relative to the executable
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    "-Wno-dev" # kill dev warnings that are useless for packaging
    (lib.cmakeBool "ENABLE_JACK" true)
    (lib.cmakeBool "ENABLE_WEBRTC" true)
    (lib.cmakeBool "ENABLE_QSV11" stdenv.hostPlatform.isx86_64)
    (lib.cmakeBool "ENABLE_LIBFDK" withFdk)
    (lib.cmakeBool "ENABLE_SCRIPTING" scriptingSupport)
    (lib.cmakeBool "ENABLE_ALSA" alsaSupport)
    (lib.cmakeBool "ENABLE_PULSEAUDIO" pulseaudioSupport)
    (lib.cmakeBool "ENABLE_PIPEWIRE" pipewireSupport)
    (lib.cmakeBool "ENABLE_AJA" false) # TODO: fix linking against libajantv2
    (lib.cmakeBool "ENABLE_BROWSER" browserSupport)
  ]
  ++ lib.optional browserSupport (lib.cmakeFeature "CEF_ROOT_DIR" "${cef}");

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=deprecated-declarations"
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
      rm $out/lib/obs-modules/core/libcef.so
      rm $out/lib/obs-modules/core/libEGL.so
      rm $out/lib/obs-modules/core/libGLESv2.so
      rm $out/lib/obs-modules/core/libvk_swiftshader.so
      rm $out/lib/obs-modules/core/libvulkan.so.1
      rm $out/lib/obs-modules/core/chrome-sandbox
    '';

  postFixup = lib.concatStrings [
    (lib.optionalString stdenv.hostPlatform.isLinux ''
      addDriverRunpath $out/lib/lib*.so
      addDriverRunpath $out/lib/obs-modules/core/*.so
    '')

    (lib.optionalString browserSupport ''
      # Link cef components again after patchelfing other libs
      ln -sf ${cef}/${cef.buildType}/* $out/lib/obs-modules/core/
    '')
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = "https://obsproject.com";
    changelog = "https://github.com/obsproject/obs-studio/releases/tag/${finalAttrs.version}";
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
    mainProgram = "obs";
  };
})
