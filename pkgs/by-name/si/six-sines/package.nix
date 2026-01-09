{
  clangStdenv,
  fetchFromGitHub,
  lib,
  cmake,
  pkg-config,
  alsa-lib,
  libpulseaudio,
  libX11,
  libXcomposite,
  libXcursor,
  libXinerama,
  libXrandr,
  libXtst,
  libXdmcp,
  libXext,
  xvfb,
  freetype,
  fontconfig,
  libGL,
  libjack2,
  curl,
  expat,
  clap,
  rtaudio_6,
  rtmidi,
  nix-update-script,
  makeDesktopItem,
  copyDesktopItems,
  python313Packages,
  gitMinimal,
}:
let
  vst3sdk = fetchFromGitHub {
    owner = "steinbergmedia";
    repo = "vst3sdk";
    tag = "v3.8.0_build_66";
    fetchSubmodules = true;
    hash = "sha256-ZGhhFic8l8xDwajTJgZPXl6M+S3QhrDX5zrCSu/Vfvg=";
  };
in
clangStdenv.mkDerivation (finalAttrs: {
  pname = "six-sines";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "baconpaul";
    repo = "six-sines";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o9klGNC7MiqsdsIaBjI3Ogl41Ccwx+k3yp6DmhUpf3Y=";
    fetchSubmodules = true;
    # The libraries want to embed the git tag/version into the final binary
    # Thus, we leave this in
    leaveDotGit = true;
  };

  desktopItem = makeDesktopItem {
    type = "Application";
    name = "six-sines";
    desktopName = "Six Sines";
    comment = "Small PM/AM Synthesizer";
    icon = "Six-Sines";
    exec = "six-sines";
    categories = [
      "Audio"
      "AudioVideo"
    ];
  };

  postPatch = ''
    # Fix build with newer versions of CMake
    substituteInPlace libs/libsamplerate/CMakeLists.txt \
        --replace-fail 'cmake_minimum_required(VERSION 3.1..3.18)' 'cmake_minimum_required(VERSION 3.18)'
    # CPM will attempt to download files in the nix sandbox, which is a big no-no, so we get rid of it
    substituteInPlace libs/clap-libs/clap-wrapper/cmake/shared_prologue.cmake \
        --replace-fail 'include(''${CLAP_WRAPPER_CMAKE_CURRENT_SOURCE_DIR}/cmake/external/CPM.cmake)' ""
    # The VST3 SDK will refuse to build with -Werror, so we have to remove it
    substituteInPlace libs/clap-libs/clap-wrapper/cmake/shared_prologue.cmake \
        --replace-fail 'target_compile_options(clap-wrapper-compile-options INTERFACE -Werror)' ""
    # By default, this tries to install the plugin during buildPhase, which fails because we do not have
    # a home directory (nor should we install during buildPhase) so this gets rid of that
    substituteInPlace CMakeLists.txt \
        --replace-fail 'COPY_AFTER_BUILD ''${COPY_AFTER_BUILD}' ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    copyDesktopItems
    gitMinimal
    python313Packages.icnsutil
  ];

  buildInputs = [
    alsa-lib
    libpulseaudio
    libX11
    libXcomposite
    libXcursor
    libXinerama
    libXrandr
    libXtst
    libXdmcp
    libXext
    libXtst
    xvfb
    libGL
    libjack2
    freetype
    fontconfig
    curl
    expat
    # There would be a gdkmm3 here, I could not get it to function
  ];

  cmakeFlags = [
    (lib.cmakeBool "CLAP_WRAPPER_DOWNLOAD_DEPENDENCIES" false)
    "-DCLAP_SDK_ROOT=${clap.src}"
    "-DVST3_SDK_ROOT=${vst3sdk}"
    "-DRTAUDIO_SDK_ROOT=${rtaudio_6.src}"
    "-DRTMIDI_SDK_ROOT=${rtmidi.src}"
    "-Bignore/build"
  ];

  strictDeps = true;

  preBuild = ''
    cd /build/source/build/ignore/build
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3 $out/lib/clap $out/bin

    install -Dm555 "/build/source/build/ignore/build/six-sines_assets/Six Sines" "$out/bin/Six Sines"
    install -Dm555 "/build/source/build/ignore/build/six-sines_assets/Six Sines.clap" "$out/lib/clap/Six Sines.clap"
    cp -r "/build/source/build/ignore/build/six-sines_assets/Six Sines.vst3" $out/lib/vst3

    # install icon
    cp $src/resources/mac_installer/Icon.icns .
    icnsutil e Icon.icns
    install -Dm444 Icon.icns.export/128x128.png $out/share/pixmaps/Six-Sines.png

    runHook postInstall
  '';

  NIX_LDFLAGS = (
    toString [
      "-lX11"
      "-lXext"
      "-lXcomposite"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
      "-lXtst"
      "-lXdmcp"
    ]
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A small synthesizer which explores audio rate inter-modulation of signals";
    homepage = "https://github.com/baconpaul/six-sines";
    mainProgram = "Six Sines";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.l1npengtul ];
  };
})
