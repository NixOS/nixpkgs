{
  lib,
  stdenv,
  fetchFromGitHub,
  chafa,
  cmake,
  darwin,
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
  overrideSDK,
  pcre,
  pcre2,
  pkg-config,
  python3,
  rpm,
  sqlite,
  testers,
  util-linux,
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
}:
let
  stdenv' = if stdenv.hostPlatform.isDarwin then overrideSDK stdenv "11.0" else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "2.28.0";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    rev = finalAttrs.version;
    hash = "sha256-fkAtBO9POd3JKNNt0jV1ufIN1s8HaFW7P2+32cRycWs=";
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
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk_11_0.frameworks;
      [
        Apple80211
        AppKit
        AVFoundation
        Cocoa
        CoreDisplay
        CoreVideo
        CoreWLAN
        DisplayServices
        IOBluetooth
        MediaRemote
        OpenCL
        SystemConfiguration
        moltenvk
      ]
    );

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
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      (lib.cmakeOptionType "filepath" "CUSTOM_PCI_IDS_PATH" "${hwdata}/share/hwdata/pci.ids")
      (lib.cmakeOptionType "filepath" "CUSTOM_AMDGPU_IDS_PATH" "${libdrm}/share/libdrm/amdgpu.ids")
    ];

  postPatch = ''
    substituteInPlace completions/fastfetch.fish --replace-fail python3 '${python3.interpreter}'
  '';

  postInstall = ''
    wrapProgram $out/bin/fastfetch \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
    wrapProgram $out/bin/flashfetch \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "fastfetch -v | cut -d '(' -f 1";
      version = "fastfetch ${finalAttrs.version}";
    };
  };

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
