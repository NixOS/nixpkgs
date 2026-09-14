{
  lib,
  stdenv,
  cmake,
  ninja,
  pkg-config,
  fetchFromGitHub,
  makeBinaryWrapper,
  makeDesktopItem,
  copyDesktopItems,
  libGL,
  mesa,
  libglvnd,
  libx11,
  libxext,
  libxrandr,
  libxcursor,
  libxi,
  libxfixes,
  alsa-lib,
  pulseaudio,
  wayland,
  libxkbcommon,
  dbus,
  udev,
  libdecor,
  wayland-scanner,
}:

stdenv.mkDerivation {
  pname = "picasim";
  version = "1.4.0";

  strictDeps = true;
  __structuredAttrs = true;

  # The Linux platform support lives on a branch that was never re-tagged.
  # Upstream's `v1.4.0` git tag (a1561069, 2026-02-18) is on a diverged line
  # that lacks `source/PicaSim/Platform/PlatformSDL.cpp` and
  # `linux_create_appimage.sh`, so the entire Linux build below would not even
  # apply. The Linux-capable tree is the "add-linux-platform" PR #8 merge at
  # 5b2c5871 (2026-05-16); upstream self-IDs as "Version 1.4.0" (VERSIONS.txt)
  # at this commit too, hence `version = "1.4.0"`.
  src = fetchFromGitHub {
    owner = "Rowlhouse";
    repo = "PicaSim";
    rev = "5b2c5871b82aecae4ae6293b862f31600a6a949c";
    fetchSubmodules = true;
    hash = "sha256-e9pTRStP1wvhwthwnYdAcvgb565D6VWKfNDZnuXadE0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    makeBinaryWrapper
    copyDesktopItems
    wayland-scanner
  ];

  buildInputs = [
    libGL
    mesa
    libglvnd
    libx11
    libxext
    libxrandr
    libxcursor
    libxi
    libxfixes
    alsa-lib
    pulseaudio
    wayland
    libxkbcommon
    dbus
    udev
    libdecor
  ];

  cmakeFlags = [
    # Upstream's Linux-desktop default builds VR support, which then calls
    # find_package(OpenXR CONFIG REQUIRED) — no OpenXR input → build fails.
    "-DPICASIM_ENABLE_VR=OFF"
    # Vendored SDL2 Vulkan backend pulls khronos/vulkan.h which needs xcb/xcb.h;
    # PicaSim is OpenGL-only.
    "-DSDL_VULKAN=OFF"
    # Vendored SDL2: skip the pipewire backend (no input).
    "-DSDL_PIPEWIRE=OFF"
    # Vendored openal-soft: ship no examples/tests.
    "-DALSOFT_EXAMPLES=OFF"
    "-DALSOFT_TESTS=OFF"
  ];

  postPatch = ''
    sed -i '/add_custom_command(TARGET PicaSim POST_BUILD/,/^    )/d' CMakeLists.txt
  '';

  installPhase = ''
    runHook preInstall

    cmake --install . --prefix "$out/opt/PicaSim"

    makeBinaryWrapper "$out/opt/PicaSim/PicaSim" "$out/bin/picasim" \
      --chdir "$out/opt/PicaSim" \
      --set SDL_VIDEODRIVER x11 # No native wayland support

    install -Dm0644 $src/resources/IconFull.png $out/share/icons/hicolor/512x512/apps/picasim.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "picasim";
      desktopName = "PicaSim";
      comment = "R/C Flight Simulator";
      exec = "picasim";
      icon = "picasim";
      categories = [
        "Game"
        "Simulation"
      ];
      terminal = false;
    })
  ];

  meta = {
    homepage = "https://rowlhouse.co.uk/PicaSim/";
    description = "Flight simulator for radio-controlled planes";
    longDescription = ''
      PicaSim is a flight simulator for radio controlled aircraft.
      At the moment it concentrates mainly on gliders, but it has a few other aircraft too.
      The upstream license is PolyForm Noncommercial 1.0.0.
    '';
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "picasim";
    maintainers = with lib.maintainers; [ panasenco ];
  };
}
