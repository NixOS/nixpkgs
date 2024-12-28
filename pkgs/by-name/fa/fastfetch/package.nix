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
  rpmSupport ? false,
  vulkanSupport ? true,
  waylandSupport ? true,
  x11Support ? true,
  flashfetchSupport ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "2.33.0";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    rev = finalAttrs.version;
    hash = "sha256-GCUG9b98UmuC/6psDs4PNAoquEWOMz0kl/IBQXRGX5o=";
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
    [
      chafa
      imagemagick
      pcre
      pcre2
      sqlite
      yyjson
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      dbus
      dconf
      ddcutil
      glib
      hwdata
      libdrm
      libpulseaudio
      libselinux
      libsepol
      ocl-icd
      opencl-headers
      util-linux
      zlib
    ]
    ++ lib.optionals rpmSupport [ rpm ]
    ++ lib.optionals vulkanSupport [ vulkan-loader ]
    ++ lib.optionals waylandSupport [ wayland ]
    ++ lib.optionals x11Support [
      libXrandr
      libglvnd
      libxcb
      xorg.libXau
      xorg.libXdmcp
      xorg.libXext
    ]
    ++ lib.optionals (x11Support && (!stdenv.hostPlatform.isDarwin)) [ xfce.xfconf ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_15
      moltenvk
    ];

  cmakeFlags =
    [
      (lib.cmakeOptionType "filepath" "CMAKE_INSTALL_SYSCONFDIR" "${placeholder "out"}/etc")
      (lib.cmakeBool "ENABLE_DIRECTX_HEADERS" false)
      (lib.cmakeBool "ENABLE_DRM" false)
      (lib.cmakeBool "ENABLE_IMAGEMAGICK6" false)
      (lib.cmakeBool "ENABLE_OSMESA" false)
      (lib.cmakeBool "ENABLE_SYSTEM_YYJSON" true)
      (lib.cmakeBool "ENABLE_GLX" x11Support)
      (lib.cmakeBool "ENABLE_RPM" rpmSupport)
      (lib.cmakeBool "ENABLE_VULKAN" x11Support)
      (lib.cmakeBool "ENABLE_WAYLAND" waylandSupport)
      (lib.cmakeBool "ENABLE_X11" x11Support)
      (lib.cmakeBool "ENABLE_XCB" x11Support)
      (lib.cmakeBool "ENABLE_XCB_RANDR" x11Support)
      (lib.cmakeBool "ENABLE_XFCONF" (x11Support && (!stdenv.hostPlatform.isDarwin)))
      (lib.cmakeBool "ENABLE_XRANDR" x11Support)
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
  };
})
