{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,

  cmake,
  ninja,
  pkg-config,
  makeWrapper,
  zip,
  gettext,
  writableDirWrapper,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,

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
  openexr,
  sqlite,
  addDriverRunpath,

  nzportable-assets,
  nzportable-quakec,

  enableEGL ? true,
  libglvnd,

  enableVulkan ? true,
  vulkan-headers,
  vulkan-loader,

  enableWayland ? false,
  wayland,
  libxkbcommon,
}:
let
  fteqwVersion = "0-unstable-2024-11-30-14-18-42";

  # We use the youngest version of all of the dependencies as the version number.
  # This is similar to what upstream uses, except ours is a bit more accurate
  # since we don't rely on a CI to run at an arbitrary time.
  dateString =
    lib.pipe
      [
        fteqwVersion
        nzportable-assets.version
        nzportable-quakec.version
      ]
      [
        # Find the youngest (most recently updated) version
        (lib.foldl' (acc: p: if lib.versionOlder acc p then p else acc) "0")
        (lib.splitString "-")
        (lib.sublist 2 6) # drop the first two segments (0 and unstable) and only keep the date
        lib.concatStrings
      ];

  description = "Call of Duty: Zombies demake, powered by various Quake sourceports (PC version)";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nzportable";
  version = "2.0.0-indev+${dateString}";

  src = fetchFromGitHub {
    owner = "nzp-team";
    repo = "fteqw";
    rev = "91e23786b4b3d8557bc421ebd8559264d407c7c2";
    hash = "sha256-GI2fshnRLuQytWtQo4hwcFH77zgdUESpQCniO5Zv3vc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    makeWrapper
    pkg-config
    zip
    gettext
    writableDirWrapper
    copyDesktopItems
    imagemagick
  ];

  buildInputs =
    [
      libGL
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
    ]
    ++ lib.optional enableEGL libglvnd
    ++ lib.optionals enableWayland [
      wayland
      libxkbcommon
    ]
    ++ lib.optional enableVulkan vulkan-headers;

  cmakeFlags =
    [
      (lib.cmakeFeature "FTE_BUILD_CONFIG" "${finalAttrs.src}/engine/common/config_nzportable.h")
      (lib.cmakeFeature "FTE_INSTALL_BINDIR" "bin")
    ]
    # Disable everything we don't use (it adds so much to the compile times)
    ++ map (k: lib.cmakeBool k false) [
      # Upstream only builds the client binary and so do we
      "FTE_ENGINE_SERVER_ONLY"
      "FTE_TOOL_IQM"
      "FTE_TOOL_IMAGE"
      "FTE_TOOL_QTV"
      "FTE_TOOL_MASTER"
      "FTE_TOOL_QCC"
      "FTE_TOOL_HTTPSV"
      "FTE_MENU_SYS"
      "FTE_CSADDON"
      "FTE_PLUG_QUAKE3"
      "FTE_PLUG_COD"
      "FTE_PLUG_QI"
      "FTE_PLUG_EZHUD"
      "FTE_PLUG_IRC"
      "FTE_PLUG_HL2"
      "FTE_PLUG_MODELS"
      "FTE_PLUG_XMPP"
    ];

  desktopItems = [
    (makeDesktopItem {
      name = "nzportable";
      desktopName = "Nazi Zombies: Portable";
      comment = description;
      icon = "nzportable";
      exec = "nzportable";
      categories = [
        "Game"
        "ActionGame"
        "Shooter"
      ];
      keywords = [
        "Zombies"
        "CoD"
      ];
      prefersNonDefaultGPU = true;
    })
  ];

  postInstall = ''
    # Remove original FTEQW desktop file
    rm $out/share/applications/fteqw.desktop
    mkdir -p $out/share/icons/hicolor/256x256/apps
    magick ${nzportable-assets}/gfx/menu/nzp_logo.tga $out/share/icons/hicolor/256x256/apps/nzportable.png
  '';

  postFixup =
    let
      # grep for `Sys_LoadLibrary` for more.
      # Some of the deps listed in the source code are actually not active
      # due to being either disabled by the nzportable profile (e.g. lua, bz2),
      # available in /run/opengl-driver,
      # or statically linked (e.g. libpng, libjpeg, zlib)
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
      ] ++ lib.optional enableWayland wayland ++ lib.optional enableVulkan vulkan-loader;

      dataDir = "\${XDG_DATA_HOME:-$HOME/.local/share}/nzportable";
    in
    ''
      mv $out/bin/fteqw $out/bin/nzportable
      wrapProgramInWritableDir $out/bin/nzportable '${dataDir}' \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libs}" \
        --add-flags '-basedir "${dataDir}"' \
        --link ${nzportable-assets.pc} . \
        --link ${nzportable-quakec.fte} ./nzp \
        --post-link-run 'cp ${dataDir}/.nzportable.version ./nzp/version.txt'
    '';

  passthru = {
    inherit fteqwVersion;
    updateScript = callPackage ./update.nix { };
  };

  meta = {
    inherit description;
    longDescription = ''
      **NZ:P relies on linking game data to `$XDG_DATA_HOME/nzportable` in order to function.**
      If you encounter any errors relating to missing game data, please run
      `nzportable --relink-files` to relink and fix any game data. Files will also be
      relinked after an update, which may cause extra loading times for the first launch.

      ---

       Nazi Zombies: Portable supports several graphics options.
       You can specify those graphics option by overriding the `nzportable` package, like this:
       ```nix
         nzportable.override {
           enableWayland = true;
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
    homepage = "https://docs.nzp.gay";
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
    mainProgram = "nzportable";
  };
})
