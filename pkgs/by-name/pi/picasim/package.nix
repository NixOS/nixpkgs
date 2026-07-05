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
  #
  # `fetchSubmodules` walks the 6 public-GitHub `.gitmodules` entries
  # (SDL2, SDL2_net, openal-soft, imgui, stb, glm). Upstream builds these
  # in-tree via add_subdirectory + a manual SDL2_net + a vendored imgui; there
  # is no find_package(SDL2) path, so we keep the vendored submodules.
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
    # generator: the stdenv cmake setup hook auto-prepends -GNinja when ninja
    # is in nativeBuildInputs.
  ];

  # Upstream's POST_BUILD hook copies VERSIONS.txt into $src/data/ at build
  # time — a write into the read-only nix store path → build fail at the link
  # stage. install(FILES) already ships VERSIONS.txt → $out/VERSIONS.txt, so
  # this copy is pure developer cruft. The sed range stops at the first
  # `    )` after the add_custom_command; no other blocks match.
  postPatch = ''
    sed -i '/add_custom_command(TARGET PicaSim POST_BUILD/,/^    )/d' CMakeLists.txt
  '';

  # The stdenv cmake setup hook provides configurePhase + ninjaBuildPhase; do
  # not override them (they inject NIX_CFLAGS/LDFLAGS, RPATH, parallel build).
  #
  # `--prefix $out` on the CLI beats upstream's FORCE'd CMAKE_INSTALL_PREFIX
  # (which would point at ${CMAKE_SOURCE_DIR}/dist/PicaSim-1_4_0, a non-existent
  # store path). The install lays out a flat $out: $out/PicaSim,
  # $out/SystemData/, $out/Menus/, $out/Fonts/, $out/VERSIONS.txt.
  #
  # The stdenv cmake setup hook cd's into $cmakeBuildDir (relative `build`)
  # during cmakeConfigurePhase and no later phase cd's back, so at installPhase
  # the cwd IS the build dir. Pass `.`; a bare relative "$cmakeBuildDir" would
  # double the path → "Not a file: $build/build/cmake_install.cmake".
  installPhase = ''
    runHook preInstall
    cmake --install . --prefix "$out"
    runHook postInstall
  '';

  # `--chdir $out` makes the app resolve its SystemData/SystemSettings/Menus/
  # Fonts relative paths at runtime. The hicolor icon is installed alongside
  # the .desktop that the `copyDesktopItems` hook flattens into
  # $out/share/applications during this same postInstall phase.
  postInstall = ''
    makeBinaryWrapper "$out/PicaSim" "$out/bin/picasim" --chdir "$out"
    install -Dm0644 $src/resources/IconFull.png $out/share/icons/hicolor/512x512/apps/picasim.png
  '';

  # Firefox-style freedesktop launcher via makeDesktopItem + the copyDesktopItems
  # setup hook. `exec = "picasim"` is intentionally a bare basename: it resolves
  # via PATH at launch to the wrapper installed above, provided the package is
  # in environment.systemPackages (NixOS) or the user profile. Do NOT inline
  # ${placeholder "out"}/bin/picasim here — that placeholder binds to the
  # makeDesktopItem sub-derivation, not this one, producing a broken Exec= path
  # into a store path with no bin/.
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
    license = lib.licenses.unfree; # PolyForm Noncommercial 1.0.0; nixpkgs lib.licenses has no polyformNoncommercial, so use unfree.
    platforms = [ "x86_64-linux" ]; # untested on aarch64-linux
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "picasim";
    maintainers = with lib.maintainers; [ panasenco ];
  };
}
