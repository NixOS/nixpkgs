{ lib
, stdenv
, nixosTests
, enableNvidiaCgToolkit ? false
, withAssets ? false
, withCoreInfo ? false
, withGamemode ? stdenv.isLinux
, withVulkan ? stdenv.isLinux
, withWayland ? stdenv.isLinux
, alsa-lib
, dbus
, fetchFromGitHub
, fetchpatch
, ffmpeg_4
, flac
, freetype
, gamemode
, libdrm
, libGL
, libGLU
, libpulseaudio
, libretro-core-info
, libv4l
, libX11
, libXdmcp
, libXext
, libxkbcommon
, libxml2
, libXxf86vm
, makeWrapper
, mbedtls_2
, mesa
, nvidia_cg_toolkit
, pkg-config
, python3
, qtbase
, retroarch-assets
, SDL2
, spirv-tools
, substituteAll
, udev
, vulkan-loader
, wayland
, wrapQtAppsHook
, zlib
}:

let
  runtimeLibs =
    lib.optional withVulkan vulkan-loader ++
    lib.optional withGamemode (lib.getLib gamemode);
in
stdenv.mkDerivation rec {
  pname = "retroarch-bare";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "RetroArch";
    hash = "sha256-oEENGehbzjJq1kTiz6gkXHMMe/rXjWPxxMoe4RqdqK4=";
    rev = "v${version}";
  };

  patches = [
    ./use-default-values-for-libretro_info_path-assets_directory.patch
    # TODO: remove those two patches in the next RetroArch release
    (fetchpatch {
      url = "https://github.com/libretro/RetroArch/commit/894c44c5ea7f1eada9207be3c29e8d5c0a7a9e1f.patch";
      hash = "sha256-ThB6jd9pmsipT8zjehz7znK/s0ofHHCJeEYBKur6sO8=";
    })
    (fetchpatch {
      url = "https://github.com/libretro/RetroArch/commit/c5bfd52159cf97312bb28fc42203c39418d1bbbd.patch";
      hash = "sha256-rb1maAvCSUgq2VtJ67iqUY+Fz00Fchl8YGG0EPm0+F0=";
    })
  ];

  nativeBuildInputs = [ pkg-config wrapQtAppsHook ] ++
    lib.optional withWayland wayland ++
    lib.optional (runtimeLibs != [ ]) makeWrapper;

  buildInputs = [
    ffmpeg_4
    flac
    freetype
    libGL
    libGLU
    libxml2
    mbedtls_2
    python3
    qtbase
    SDL2
    spirv-tools
    zlib
  ] ++
  lib.optional enableNvidiaCgToolkit nvidia_cg_toolkit ++
  lib.optional withVulkan vulkan-loader ++
  lib.optional withWayland wayland ++
  lib.optionals stdenv.isLinux [
    alsa-lib
    dbus
    libX11
    libXdmcp
    libXext
    libXxf86vm
    libdrm
    libpulseaudio
    libv4l
    libxkbcommon
    mesa
    udev
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-update_cores"
    "--disable-builtinmbedtls"
    "--enable-systemmbedtls"
    "--disable-builtinzlib"
    "--disable-builtinflac"
  ] ++
  lib.optionals withAssets [
    "--disable-update_assets"
    "--with-assets_dir=${retroarch-assets}/share"
  ] ++
  lib.optionals withCoreInfo [
    "--disable-update_core_info"
    "--with-core_info_dir=${libretro-core-info}/share"
  ] ++
  lib.optionals stdenv.isLinux [
    "--enable-dbus"
    "--enable-egl"
    "--enable-kms"
  ];

  postInstall = lib.optionalString (runtimeLibs != [ ]) ''
    wrapProgram $out/bin/retroarch \
      --prefix LD_LIBRARY_PATH ':' ${lib.makeLibraryPath runtimeLibs}
  '' +
  lib.optionalString enableNvidiaCgToolkit ''
    wrapProgram $out/bin/retroarch-cg2glsl \
      --prefix PATH ':' ${lib.makeBinPath [ nvidia_cg_toolkit ]}
  '';

  preFixup = lib.optionalString (!enableNvidiaCgToolkit) ''
    rm $out/bin/retroarch-cg2glsl
    rm $out/share/man/man6/retroarch-cg2glsl.6*
  '';

  passthru.tests = nixosTests.retroarch;

  meta = with lib; {
    homepage = "https://libretro.com";
    description = "Multi-platform emulator frontend for libretro cores";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    changelog = "https://github.com/libretro/RetroArch/blob/v${version}/CHANGES.md";
    maintainers = with maintainers; teams.libretro.members ++ [ matthewbauer kolbycrouch ];
    mainProgram = "retroarch";
    # If you want to (re)-add support for macOS, see:
    # https://docs.libretro.com/development/retroarch/compilation/osx/
    # and
    # https://github.com/libretro/RetroArch/blob/71eb74d256cb4dc5b8b43991aec74980547c5069/.gitlab-ci.yml#L330
    broken = stdenv.isDarwin;
  };
}
