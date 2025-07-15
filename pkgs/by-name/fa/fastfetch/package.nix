{
  lib,
  stdenv,
  fetchFromGitHub,
  apple-sdk_15,
  chafa,
  cmake,
  dbus,
  dconf,
  ddcutil,
  glib,
  hwdata,
  imagemagick,
  libXrandr,
  libdrm,
  libelf,
  libglvnd,
  libpulseaudio,
  libselinux,
  libsepol,
  libsysprof-capture,
  libxcb,
  makeBinaryWrapper,
  moltenvk,
  nix-update-script,
  ocl-icd,
  opencl-headers,
  pcre2,
  pkg-config,
  python3,
  rpm,
  sqlite,
  util-linux,
  versionCheckHook,
  vulkan-loader,
  wayland,
  xfce,
  xorg,
  yyjson,
  zlib,
  zfs,
  # Feature flags
  audioSupport ? true,
  brightnessSupport ? true,
  dbusSupport ? true,
  flashfetchSupport ? false,
  terminalSupport ? true,
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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "2.47.0";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    tag = finalAttrs.version;
    hash = "sha256-xe86u40zW1+2O4s6e64HlpxiaLIRpjgKLPNnSEGlioQ=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
    python3
  ];

  buildInputs =
    let
      commonDeps = [
        yyjson
      ];

      # Cross-platform optional dependencies
      imageDeps = lib.optionals imageSupport [
        # Image output as ascii art.
        chafa
        # Images in terminal using sixel or kitty graphics protocol
        imagemagick
      ];

      sqliteDeps = lib.optionals sqliteSupport [
        # linux - Needed for pkg & rpm package count.
        # darwin - Used for fast wallpaper detection before macOS Sonoma
        sqlite
      ];

      linuxCoreDeps = lib.optionals stdenv.hostPlatform.isLinux (
        [
          hwdata
        ]
        # Fallback if both `wayland` and `x11` are not available. AMD GPU properties detection
        ++ lib.optional (!x11Support && !waylandSupport) libdrm
      );

      linuxFeatureDeps = lib.optionals stdenv.hostPlatform.isLinux (
        lib.optionals audioSupport [
          # Sound device detection
          libpulseaudio
        ]
        ++ lib.optionals brightnessSupport [
          # Brightness detection of external displays
          ddcutil
        ]
        ++ lib.optionals dbusSupport [
          # Bluetooth, wifi, player & media detection
          dbus
        ]
        ++ lib.optionals gnomeSupport [
          # Needed for values that are only stored in DConf + Fallback for GSettings.
          dconf
          glib
          # Required by glib messages
          libsysprof-capture
          pcre2
          # Required by gio messages
          libselinux
          util-linux
          # Required by selinux
          libsepol
        ]
        ++ lib.optionals imageSupport [
          # Faster image output when using kitty graphics protocol.
          zlib
        ]
        ++ lib.optionals openclSupport [
          # OpenCL module
          ocl-icd
          opencl-headers
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
          # Better display performance and output in wayland sessions. Supports different refresh rates per monitor.
          wayland
        ]
        ++ lib.optionals x11Support [
          # At least one of them sould be present in X11 sessions for better display detection and faster WM detection.
          # The *randr ones provide multi monitor support The libxcb* ones usually have better performance.
          libXrandr
          libxcb
          # Required by libxcb messages
          xorg.libXau
          xorg.libXdmcp
          xorg.libXext
        ]
        ++ lib.optionals xfceSupport [
          #  Needed for XFWM theme and XFCE Terminal font.
          xfce.xfconf
        ]
        ++ lib.optionals zfsSupport [
          # Needed for zpool module
          zfs
        ]
      );

      macosDeps = lib.optionals stdenv.hostPlatform.isDarwin [
        apple-sdk_15
        moltenvk
      ];
    in
    commonDeps ++ imageDeps ++ sqliteDeps ++ linuxCoreDeps ++ linuxFeatureDeps ++ macosDeps;

  cmakeFlags =
    [
      (lib.cmakeOptionType "filepath" "CMAKE_INSTALL_SYSCONFDIR" "${placeholder "out"}/etc")
      (lib.cmakeBool "ENABLE_DIRECTX_HEADERS" false)
      (lib.cmakeBool "ENABLE_SYSTEM_YYJSON" true)

      # Feature flags
      (lib.cmakeBool "BUILD_FLASHFETCH" flashfetchSupport)

      (lib.cmakeBool "ENABLE_IMAGEMAGICK6" false)
      (lib.cmakeBool "ENABLE_IMAGEMAGICK7" imageSupport)
      (lib.cmakeBool "ENABLE_CHAFA" imageSupport)

      (lib.cmakeBool "ENABLE_SQLITE3" sqliteSupport)

      (lib.cmakeBool "ENABLE_LIBZFS" zfsSupport)
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      (lib.cmakeBool "ENABLE_PULSE" audioSupport)

      (lib.cmakeBool "ENABLE_DDCUTIL" brightnessSupport)

      (lib.cmakeBool "ENABLE_DBUS" dbusSupport)

      (lib.cmakeBool "ENABLE_ELF" terminalSupport)

      (lib.cmakeBool "ENABLE_GIO" gnomeSupport)
      (lib.cmakeBool "ENABLE_DCONF" gnomeSupport)

      (lib.cmakeBool "ENABLE_ZLIB" imageSupport)

      (lib.cmakeBool "ENABLE_OPENCL" openclSupport)

      (lib.cmakeBool "ENABLE_EGL" openglSupport)
      (lib.cmakeBool "ENABLE_GLX" openglSupport)

      (lib.cmakeBool "ENABLE_RPM" rpmSupport)

      (lib.cmakeBool "ENABLE_DRM" (!x11Support && !waylandSupport))
      (lib.cmakeBool "ENABLE_DRM_AMDGPU" (!x11Support && !waylandSupport))

      (lib.cmakeBool "ENABLE_VULKAN" vulkanSupport)

      (lib.cmakeBool "ENABLE_WAYLAND" waylandSupport)

      (lib.cmakeBool "ENABLE_XCB_RANDR" x11Support)
      (lib.cmakeBool "ENABLE_XRANDR" x11Support)

      (lib.cmakeBool "ENABLE_XFCONF" xfceSupport)

      (lib.cmakeOptionType "filepath" "CUSTOM_PCI_IDS_PATH" "${hwdata}/share/hwdata/pci.ids")
      (lib.cmakeOptionType "filepath" "CUSTOM_AMDGPU_IDS_PATH" "${libdrm}/share/libdrm/amdgpu.ids")
    ];

  postPatch = ''
    substituteInPlace completions/fastfetch.{bash,fish,zsh} --replace-fail python3 '${python3.interpreter}'
  '';

  postInstall =
    ''
      wrapProgram $out/bin/fastfetch \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
    ''
    + lib.optionalString flashfetchSupport ''
      wrapProgram $out/bin/flashfetch \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Actively maintained, feature-rich and performance oriented, neofetch like system information tool";
    homepage = "https://github.com/fastfetch-cli/fastfetch";
    changelog = "https://github.com/fastfetch-cli/fastfetch/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      khaneliman
    ];
    platforms = lib.platforms.all;
    mainProgram = "fastfetch";
    longDescription = ''
      Fast and highly customizable system info script.

      Feature flags (all default to 'true' except rpmSupport, flashfetchSupport and zfsSupport):
      * audioSupport: PulseAudio functionality
      * brightnessSupport: External display brightness detection via DDCUtil
      * dbusSupport: DBus functionality for Bluetooth, WiFi, player & media detection
      * flashfetchSupport: Build the flashfetch utility (default: false)
      * gnomeSupport: GNOME integration (dconf, dbus, gio)
      * imageSupport: Image rendering (chafa and imagemagick)
      * openclSupport: OpenCL features
      * openglSupport: OpenGL features
      * rpmSupport: RPM package detection (default: false)
      * sqliteSupport: Package counting via SQLite
      * terminalSupport: Terminal font detection
      * vulkanSupport: Vulkan GPU information and DRM features
      * waylandSupport: Wayland display detection
      * x11Support: X11 display information
      * xfceSupport: XFCE integration for theme and terminal font detection
      * zfsSupport: zpool information
    '';
  };
})
