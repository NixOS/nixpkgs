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
  pcre,
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
  # Feature flags
  audioSupport ? true,
  flashfetchSupport ? false,
  gnomeSupport ? true,
  imageSupport ? true,
  openclSupport ? true,
  rpmSupport ? false,
  sqliteSupport ? true,
  vulkanSupport ? true,
  waylandSupport ? true,
  x11Support ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "2.42.0";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    tag = finalAttrs.version;
    hash = "sha256-nlhW3ftBOjb2BHz1qjOI4VGiSn1+VAUcaA9n0nPikCU=";
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
        pcre
        pcre2
        yyjson
      ];

      # Cross-platform optional dependencies
      imageDeps = lib.optionals imageSupport [
        chafa
        imagemagick
      ];

      sqliteDeps = lib.optionals sqliteSupport [
        sqlite
      ];

      linuxCoreDeps = lib.optionals stdenv.hostPlatform.isLinux [
        hwdata
        libselinux
        libsepol
        util-linux
        zlib
      ];

      linuxFeatureDeps = lib.optionals stdenv.hostPlatform.isLinux (
        lib.optionals gnomeSupport [
          dbus
          dconf
          glib
          libsysprof-capture
        ]
        ++ lib.optionals audioSupport [
          libpulseaudio
        ]
        ++ lib.optionals openclSupport [
          ocl-icd
          opencl-headers
        ]
        ++ lib.optionals vulkanSupport [
          libdrm
          ddcutil
        ]
        ++ lib.optionals rpmSupport [
          rpm
        ]
      );

      waylandDeps = lib.optionals waylandSupport [
        wayland
      ];

      vulkanDeps = lib.optionals vulkanSupport [
        vulkan-loader
      ];

      x11Deps = lib.optionals x11Support [
        libXrandr
        libglvnd
        libxcb
        xorg.libXau
        xorg.libXdmcp
        xorg.libXext
      ];

      x11XfceDeps = lib.optionals (x11Support && (!stdenv.hostPlatform.isDarwin)) [
        xfce.xfconf
      ];

      macosDeps = lib.optionals stdenv.hostPlatform.isDarwin [
        apple-sdk_15
        moltenvk
      ];
    in
    commonDeps
    ++ imageDeps
    ++ sqliteDeps
    ++ linuxCoreDeps
    ++ linuxFeatureDeps
    ++ waylandDeps
    ++ vulkanDeps
    ++ x11Deps
    ++ x11XfceDeps
    ++ macosDeps;

  cmakeFlags =
    [
      (lib.cmakeOptionType "filepath" "CMAKE_INSTALL_SYSCONFDIR" "${placeholder "out"}/etc")
      (lib.cmakeBool "ENABLE_DIRECTX_HEADERS" false)
      (lib.cmakeBool "ENABLE_OSMESA" false)
      (lib.cmakeBool "ENABLE_SYSTEM_YYJSON" true)

      # Feature flags
      (lib.cmakeBool "ENABLE_IMAGEMAGICK6" false)
      (lib.cmakeBool "ENABLE_IMAGEMAGICK7" imageSupport)
      (lib.cmakeBool "ENABLE_CHAFA" imageSupport)
      (lib.cmakeBool "ENABLE_ZLIB" imageSupport)

      (lib.cmakeBool "ENABLE_SQLITE3" sqliteSupport)

      (lib.cmakeBool "ENABLE_PULSE" audioSupport)

      (lib.cmakeBool "ENABLE_GIO" gnomeSupport)
      (lib.cmakeBool "ENABLE_DCONF" gnomeSupport)
      (lib.cmakeBool "ENABLE_DBUS" gnomeSupport)

      (lib.cmakeBool "ENABLE_OPENCL" openclSupport)

      (lib.cmakeBool "ENABLE_DRM" vulkanSupport)
      (lib.cmakeBool "ENABLE_DRM_AMDGPU" vulkanSupport)
      (lib.cmakeBool "ENABLE_VULKAN" vulkanSupport)
      (lib.cmakeBool "ENABLE_DDCUTIL" vulkanSupport)
      (lib.cmakeBool "ENABLE_EGL" vulkanSupport)

      (lib.cmakeBool "ENABLE_WAYLAND" waylandSupport)

      (lib.cmakeBool "ENABLE_GLX" x11Support)
      (lib.cmakeBool "ENABLE_X11" x11Support)
      (lib.cmakeBool "ENABLE_XCB" x11Support)
      (lib.cmakeBool "ENABLE_XCB_RANDR" x11Support)
      (lib.cmakeBool "ENABLE_XFCONF" (x11Support && (!stdenv.hostPlatform.isDarwin)))
      (lib.cmakeBool "ENABLE_XRANDR" x11Support)

      (lib.cmakeBool "ENABLE_RPM" rpmSupport)

      (lib.cmakeBool "BUILD_FLASHFETCH" flashfetchSupport)
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      (lib.cmakeOptionType "filepath" "CUSTOM_PCI_IDS_PATH" "${hwdata}/share/hwdata/pci.ids")
      (lib.cmakeOptionType "filepath" "CUSTOM_AMDGPU_IDS_PATH" "${libdrm}/share/libdrm/amdgpu.ids")
    ];

  postPatch = ''
    substituteInPlace completions/fastfetch.fish --replace-fail python3 '${python3.interpreter}'
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
    description = "An actively maintained, feature-rich and performance oriented, neofetch like system information tool";
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

      Feature flags (all default to 'true' except rpmSupport and flashfetchSupport):
      * rpmSupport: RPM package detection (default: false)
      * vulkanSupport: Vulkan GPU information and DRM features
      * waylandSupport: Wayland display detection
      * x11Support: X11 display information
      * flashfetchSupport: Build the flashfetch utility (default: false)
      * imageSupport: Image rendering (chafa and imagemagick)
      * sqliteSupport: Package counting via SQLite
      * audioSupport: PulseAudio functionality
      * gnomeSupport: GNOME integration (dconf, dbus, gio)
      * openclSupport: OpenCL features
    '';
  };
})
