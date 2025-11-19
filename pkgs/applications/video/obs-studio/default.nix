{
  config,
  uthash,
  lib,
  stdenv,
  ninja,
  nv-codec-headers-12,
  fetchFromGitHub,
  fetchpatch2,
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
  libpthreadstubs,
  libXdmcp,
  qtbase,
  qtsvg,
  speex,
  libv4l,
  x264,
  curl,
  wayland,
  xorg,
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
  pulseaudioSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,
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
  qtwayland,
  wrapQtAppsHook,
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
  extra-cmake-modules,
}:

let
  inherit (lib) optional optionals;

  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");

  cef = cef-binary.overrideAttrs (
    oldAttrs:
    let
      version = "6533";
      revision = "6";
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
          aarch64-linux = "sha256-ZCUURp6qKaXIh4kQhNLnP33C10Bfffp3JrLbwkswmZk=";
          x86_64-linux = "sha256-eWMzVRmhnM3FIz9zNMWrAjAm4vPpoMxBcAfAnYZggUY=";
        };
      };
    }
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "obs-studio";
  version = "32.0.1";

  src = fetchFromGitHub {
    owner = "obsproject";
    repo = "obs-studio";
    rev = finalAttrs.version;
    hash = "sha256-99VAVV3hEMDI2R30OrX/in/9KtesUxMGOPg6yT5e4oM=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  patches = [
    ./fix-nix-plugin-path.patch
    # Fix build with Qt 6.10 https://github.com/obsproject/obs-studio/pull/12328
    (fetchpatch2 {
      url = "https://github.com/obsproject/obs-studio/commit/26dfacbd4f5217258a2f1c5472a544c65a182d10.patch?full_index=1";
      hash = "sha256-gEWDzZ+GPCR+rmytXcbiBcvzLg8VwZCveMKkvho3COI=";
    })
  ];

  nativeBuildInputs = [
    addDriverRunpath
    cmake
    ninja
    pkg-config
    wrapGAppsHook3
    wrapQtAppsHook
    extra-cmake-modules
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
    libpthreadstubs
    libXdmcp
    qtbase
    qtsvg
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
    qtwayland
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

  # Copied from the obs-linuxbrowser
  postUnpack = lib.optionalString browserSupport ''
    ln -s ${cef} cef
  '';

  postPatch = ''
    cp ${./CMakeUserPresets.json} ./CMakeUserPresets.json
  '';

  cmakeFlags = [
    "--preset"
    "nixpkgs-${if stdenv.hostPlatform.isDarwin then "darwin" else "linux"}"
    "-DOBS_VERSION_OVERRIDE=${finalAttrs.version}"
    "-Wno-dev" # kill dev warnings that are useless for packaging
    "-DENABLE_JACK=ON"
    "-DENABLE_WEBRTC=ON"
    (lib.cmakeBool "ENABLE_QSV11" stdenv.hostPlatform.isx86_64)
    (lib.cmakeBool "ENABLE_LIBFDK" withFdk)
    (lib.cmakeBool "ENABLE_ALSA" alsaSupport)
    (lib.cmakeBool "ENABLE_PULSEAUDIO" pulseaudioSupport)
    (lib.cmakeBool "ENABLE_PIPEWIRE" pipewireSupport)
    (lib.cmakeBool "ENABLE_AJA" false) # TODO: fix linking against libajantv2
    (lib.cmakeBool "ENABLE_BROWSER" browserSupport)
  ]
  ++ lib.optional browserSupport "-DCEF_ROOT_DIR=../../cef";

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=deprecated-declarations"
    "-Wno-error=sign-compare" # https://github.com/obsproject/obs-studio/issues/10200
    "-Wno-error=stringop-overflow="
  ];

  dontWrapGApps = true;
  preFixup =
    let
      wrapperLibraries = [
        xorg.libX11
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = "https://obsproject.com";
    maintainers = with maintainers; [
      jb55
      materus
      fpletz
    ];
    license = with licenses; [ gpl2Plus ] ++ optional withFdk fraunhofer-fdk;
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];
    mainProgram = "obs";
  };
})
