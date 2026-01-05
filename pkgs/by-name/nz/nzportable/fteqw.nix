{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  ninja,
  pkg-config,
  makeWrapper,
  zip,
  gettext,

  libpng,
  zlib,
  gnutls,
  libGL,
  xorg,
  alsa-lib,
  libjpeg,
  libogg,
  libvorbis,
  libopus,
  dbus,
  fontconfig,
  SDL2,
  bullet,
  openexr,
  sqlite,
  addDriverRunpath,

  enableEGL ? true,
  libglvnd,

  enableVulkan ? true,
  vulkan-headers,
  vulkan-loader,

  enableWayland ? true,
  wayland,
  libxkbcommon,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nzp-fteqw";
  version = "0-unstable-2024-09-11";

  src = fetchFromGitHub {
    owner = "nzp-team";
    repo = "fteqw";
    rev = "593345a7f03245fc45580ac252857e5db5105033";
    hash = "sha256-ANDHh4PKh8fAvbBiiW47l1XeGOCes0Sg595+65NFG6w=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    makeWrapper
    pkg-config
    zip
    gettext
  ];

  buildInputs = [
    libGL
    xorg.libxcb
    xorg.libX11
    xorg.libXrandr
    xorg.libXcursor
    xorg.libXScrnSaver
    dbus
    fontconfig
    libjpeg
    libpng
    alsa-lib
    libogg
    libvorbis
    libopus
    SDL2
    gnutls
    zlib
    bullet
  ]
  ++ lib.optional enableEGL libglvnd
  ++ lib.optionals enableWayland [
    wayland
    libxkbcommon
  ]
  ++ lib.optional enableVulkan vulkan-headers;

  cmakeFlags = [
    (lib.cmakeFeature "FTE_BUILD_CONFIG" "${finalAttrs.src}/engine/common/config_nzportable.h")
    # Disable optional tools - only keep FTEQCC
    (lib.cmakeBool "FTE_TOOL_IQM" false)
    (lib.cmakeBool "FTE_TOOL_IMAGE" false)
    (lib.cmakeBool "FTE_TOOL_QTV" false)
    (lib.cmakeBool "FTE_TOOL_MASTER" false)
  ];

  postInstall = ''
    mv $out/games $out/bin
  '';

  postFixup =
    let
      # grep for `Sys_LoadLibrary` for more.
      # Some of the deps listed in the source code are actually not active
      # due to being either disabled by the nzportable profile (e.g. lua, bz2),
      # available in /run/opengl-driver,
      # or statically linked (e.g. libpng, libjpeg, zlib, freetype)
      # Some of them are also just deprecated by better backend options
      # (SDL audio is preferred over ALSA, OpenAL and PulseAudio, for example)

      libs = [
        addDriverRunpath.driverLink

        # gl/gl_vidlinuxglx.c
        xorg.libX11
        xorg.libXrandr
        xorg.libXxf86vm
        xorg.libXxf86dga
        xorg.libXi
        xorg.libXcursor
        libGL

        libvorbis

        sqlite # server/sv_sql.c

        SDL2 # a lot of different files
        gnutls # common/net_ssl_gnutls.c
        openexr # client/image.c

        (placeholder "out")
      ]
      ++ lib.optional enableWayland wayland
      ++ lib.optional enableVulkan vulkan-loader;
    in
    ''
      wrapProgram $out/bin/fteqw \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libs}"
    '';

  meta = {
    description = "Nazi Zombies: Portable's fork of Spike's FTEQW engine/client";
    longDescription = ''
      This package contains only the FTEQW engine, and none of the assets used in NZ:P.
      Please use the `nzportable` package for an out-of-the-box NZ:P experience.

      FTEQW supports several graphics options.
      You can specify those graphics option by overriding the FTEQW package, like this:
      ```nix
        nzp-fteqw.override {
          enableVulkan = true;
        }
      ```
      And in the game, you need to run `setrenderer <renderer>` to change the current renderer.

      Supported graphics options are as follows:
      - `enableEGL`: Enable the OpenGL ES renderer (`egl`). Enabled by default.
      - `enableVulkan`: Enable the Vulkan renderer (`xvk`). Enabled by default.
      - `enableWayland`: Enable native Wayland support, instead of using X11.
        Adds up to two renderers, based on whether EGL and Vulkan are installed: `wlgl` and `wlvk`.
        Seems to be currently broken and currently not enabled by default.
    '';
    homepage = "https://github.com/nzp-team/fteqw";
    license = lib.licenses.gpl2Plus;
    # See README
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "armv7l-linux"
      "aarch64-linux"
      "x86_64-windows"
      "i686-windows"
    ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "fteqw";
  };
})
