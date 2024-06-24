{
  cmake,
  fetchFromGitHub,
  lib,
  llvmPackages_17,
  callPackage,
  cubeb,
  curl,
  extra-cmake-modules,
  ffmpeg,
  libaio,
  libbacktrace,
  libpcap,
  libwebp,
  libXrandr,
  lz4,
  makeWrapper,
  pkg-config,
  qt6,
  SDL2,
  soundtouch,
  strip-nondeterminism,
  vulkan-headers,
  vulkan-loader,
  wayland,
  zip,
  zstd,

  pname,
  version,
  meta,
}:

let
  shaderc-patched = callPackage ./shaderc-patched.nix { };
  # The pre-zipped files in releases don't have a versioned link, we need to zip them ourselves
  pcsx2_patches = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2_patches";
    rev = "9e71956797332471010e563a4b75a5934bef9d4e";
    hash = "sha256-jpaRpvJox78zRGyrVIGYVoSEo/ICBlBfw3dTMz9QGuU=";
  };
  inherit (qt6)
    qtbase
    qtsvg
    qttools
    qtwayland
    wrapQtAppsHook
    ;
in
llvmPackages_17.stdenv.mkDerivation (finalAttrs: {
  inherit pname version meta;

  src = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2";
    rev = "v${finalAttrs.version}";
    # NOTE: Don't forget to change the hash in shaderc-patched.nix as well.
    hash = "sha256-cDugEbbz40uLPW64bcDGxfo1Y3ahYnEVaalfMp/J95s=";
  };

  patches = [ ./define-rev.patch ];

  cmakeFlags = [
    (lib.cmakeBool "DISABLE_ADVANCE_SIMD" true)
    (lib.cmakeBool "USE_LINKED_FFMPEG" true)
    (lib.cmakeFeature "PCSX2_GIT_REV" finalAttrs.src.rev)
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    strip-nondeterminism
    wrapQtAppsHook
    zip
  ];

  buildInputs = [
    curl
    ffmpeg
    libaio
    libbacktrace
    libpcap
    libwebp
    libXrandr
    lz4
    qtbase
    qtsvg
    qttools
    qtwayland
    SDL2
    shaderc-patched
    soundtouch
    vulkan-headers
    wayland
    zstd
  ] ++ cubeb.passthru.backendLibs;

  installPhase = ''
    mkdir -p $out/bin
    cp -a bin/pcsx2-qt bin/resources $out/bin/

    install -Dm644 $src/pcsx2-qt/resources/icons/AppIcon64.png $out/share/pixmaps/PCSX2.png
    install -Dm644 $src/.github/workflows/scripts/linux/pcsx2-qt.desktop $out/share/applications/PCSX2.desktop

    zip -jq $out/bin/resources/patches.zip ${pcsx2_patches}/patches/*
    strip-nondeterminism $out/bin/resources/patches.zip
  '';

  qtWrapperArgs =
    let
      libs = lib.makeLibraryPath (
        [
          vulkan-loader
          shaderc-patched
        ]
        ++ cubeb.passthru.backendLibs
      );
    in
    [ "--prefix LD_LIBRARY_PATH : ${libs}" ];

  # https://github.com/PCSX2/pcsx2/pull/10200
  # Can't avoid the double wrapping, the binary wrapper from qtWrapperArgs doesn't support --run
  postFixup = ''
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/pcsx2-qt \
      --run 'if [[ -z $I_WANT_A_BROKEN_WAYLAND_UI ]]; then export QT_QPA_PLATFORM=xcb; fi'
  '';
})
