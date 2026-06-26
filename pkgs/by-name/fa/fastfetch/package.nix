{
  lib,
  stdenv,
  runCommand,
  apple-sdk_15,
  chafa,
  dbus,
  dconf,
  ddcutil,
  enlightenment,
  glib,
  imagemagick,
  libdrm,
  libelf,
  libglvnd,
  libpulseaudio,
  libva,
  libvdpau,
  libxcb,
  libxrandr,
  makeBinaryWrapper,
  moltenvk,
  ocl-icd,
  rpm,
  sqlite,
  vulkan-loader,
  wayland,
  xfconf,
  zfs,
  zlib,
  fastfetch-unwrapped,

  # Runtime dependency selectors. fastfetch-unwrapped is always built with support enabled.
  audioSupport ? true,
  brightnessSupport ? true,
  codecSupport ? true,
  dbusSupport ? true,
  flashfetchSupport ? false,
  terminalSupport ? true,
  # NOTE: disabled by default until lib dependency closure is minimal
  enlightenmentSupport ? false,
  gnomeSupport ? true,
  imageSupport ? true,
  openclSupport ? true,
  openglSupport ? true,
  rpmSupport ? false,
  sqliteSupport ? true,
  vulkanSupport ? true,
  waylandSupport ? true,
  x11Support ? true,
  xfceSupport ? true,
  zfsSupport ? false,

  runtimeDependencies ? null,
  extraRuntimeDependencies ? [ ],
  runtimePrograms ? [ ],
  extraRuntimePrograms ? [ ],
}:

let
  unwrapped = fastfetch-unwrapped;

  defaultRuntimeDependencies =
    lib.optionals imageSupport [
      # Image output as ascii art.
      chafa
      # Images in terminal using sixel or kitty graphics protocol
      imagemagick
    ]
    ++ lib.optionals sqliteSupport [
      # linux - Needed for pkg & rpm package count.
      # darwin - Used for fast wallpaper detection before macOS Sonoma
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux (
      [
        # DRM display and AMD GPU detection.
        libdrm
      ]
      ++ lib.optionals audioSupport [
        # Sound device detection
        libpulseaudio
      ]
      ++ lib.optionals brightnessSupport [
        # Brightness detection of external displays
        ddcutil
      ]
      ++ lib.optionals codecSupport [
        # Hardware-accelerated video codec detection
        libva
        libvdpau
      ]
      ++ lib.optionals dbusSupport [
        # Bluetooth, wifi, player & media detection
        dbus
      ]
      ++ lib.optionals enlightenmentSupport [
        # Eet support for reading Enlightenment window manager configuration.
        enlightenment.efl
      ]
      ++ lib.optionals gnomeSupport [
        # Needed for values that are only stored in DConf + Fallback for GSettings.
        dconf
        glib
      ]
      ++ lib.optionals imageSupport [
        # Faster image output when using kitty graphics protocol.
        zlib
      ]
      ++ lib.optionals openclSupport [
        # OpenCL module
        ocl-icd
      ]
      ++ lib.optionals openglSupport [
        # OpenGL module
        libglvnd
      ]
      ++ lib.optionals rpmSupport [
        # Slower fallback for rpm package count. Needed on openSUSE.
        rpm
      ]
      ++ lib.optionals terminalSupport [
        # Needed for st terminal font detection.
        libelf
      ]
      ++ lib.optionals vulkanSupport [
        # Vulkan module & fallback for GPU output
        vulkan-loader
      ]
      ++ lib.optionals waylandSupport [
        # Better display performance and output in wayland sessions.
        wayland
      ]
      ++ lib.optionals x11Support [
        # Better display detection and faster WM detection in X11 sessions.
        libxrandr
        libxcb
      ]
      ++ lib.optionals xfceSupport [
        # Needed for XFWM theme and XFCE Terminal font.
        xfconf
      ]
      ++ lib.optionals zfsSupport [
        # Needed for zpool module
        zfs
      ]
    )
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_15
      moltenvk
    ];

  resolvedRuntimeDependencies =
    (if runtimeDependencies == null then defaultRuntimeDependencies else runtimeDependencies)
    ++ extraRuntimeDependencies;

  resolvedRuntimePrograms = runtimePrograms ++ extraRuntimePrograms;

  runtimeLibraryPath = lib.makeLibraryPath resolvedRuntimeDependencies;
  runtimeProgramPath = lib.makeBinPath resolvedRuntimePrograms;
in
runCommand "fastfetch-${unwrapped.version}"
  {
    pname = "fastfetch";
    inherit (unwrapped) version;

    strictDeps = true;
    __structuredAttrs = true;

    outputs = [
      "out"
      "man"
    ];

    nativeBuildInputs = [ makeBinaryWrapper ];

    passthru = (removeAttrs unwrapped.passthru [ "updateScript" ]) // {
      inherit unwrapped;
      runtimeDependencies = resolvedRuntimeDependencies;
      runtimePrograms = resolvedRuntimePrograms;
      minimal = lib.warnOnInstantiate "`fastfetch.minimal` has been renamed to `fastfetch-unwrapped`" unwrapped;
    };

    meta = unwrapped.meta // {
      priority = (unwrapped.meta.priority or lib.meta.defaultPriority) - 1;
      longDescription = ''
        Fast and highly customizable system info script.

        This wrapped package makes optional runtime libraries available to the
        full-featured fastfetch-unwrapped binary.
      '';
    };

    preferLocalBuild = true;
  }
  ''
    makeWrapperArgs=(--inherit-argv0)

    if [ -n "${runtimeLibraryPath}" ]; then
      makeWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${runtimeLibraryPath}")
    fi

    if [ -n "${runtimeProgramPath}" ]; then
      makeWrapperArgs+=(--prefix PATH : "${runtimeProgramPath}")
    fi

    mkdir -p "$out/bin"
    makeWrapper ${unwrapped}/bin/fastfetch "$out/bin/fastfetch" "''${makeWrapperArgs[@]}"

    ${lib.optionalString flashfetchSupport ''
      makeWrapper ${unwrapped}/bin/flashfetch "$out/bin/flashfetch" "''${makeWrapperArgs[@]}"
    ''}

    ln -s ${unwrapped}/share "$out/share"

    ln -s ${unwrapped.man} "$man"
  ''
