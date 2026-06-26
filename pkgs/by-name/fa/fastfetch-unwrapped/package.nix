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
  enlightenment,
  glib,
  hwdata,
  imagemagick,
  libdrm,
  libelf,
  libglvnd,
  libpulseaudio,
  libselinux,
  libsepol,
  libsysprof-capture,
  libva,
  libvdpau,
  libxau,
  libxcb,
  libxdmcp,
  libxext,
  libxrandr,
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
  xfconf,
  yyjson,
  zfs,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch-unwrapped";
  version = "2.65.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    tag = finalAttrs.version;
    hash = "sha256-fr/FyGcURlauCLIAYHGhtmsJqbbPe+Hg3ObyRtYR5wk=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    chafa
    imagemagick
    sqlite
    yyjson
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    dconf
    ddcutil
    enlightenment.efl
    glib
    libdrm
    libelf
    libglvnd
    libpulseaudio
    libselinux
    libsepol
    libsysprof-capture
    libva
    libvdpau
    libxau
    libxcb
    libxdmcp
    libxext
    libxrandr
    ocl-icd
    opencl-headers
    pcre2
    rpm
    util-linux
    vulkan-loader
    wayland
    xfconf
    zfs
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
    moltenvk
  ];

  cmakeFlags = [
    (lib.cmakeOptionType "filepath" "CMAKE_INSTALL_SYSCONFDIR" "${placeholder "out"}/etc")
    (lib.cmakeBool "ENABLE_DIRECTX_HEADERS" false)
    (lib.cmakeBool "ENABLE_SYSTEM_YYJSON" true)

    # Upstream defaults optional feature support to on when the platform allows it.
    (lib.cmakeBool "ENABLE_IMAGEMAGICK6" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # Embed these databases instead of referring to hwdata and libdrm at runtime.
    (lib.cmakeBool "ENABLE_EMBEDDED_PCIIDS" true)
    (lib.cmakeBool "ENABLE_EMBEDDED_AMDGPUIDS" true)
  ];

  # Upstream completions run Python when shells expand options from
  # `fastfetch --help-raw`. Keep this runtime dependency explicit until
  # upstream generates static completions at build time.
  postPatch = ''
    substituteInPlace completions/fastfetch.{bash,fish,zsh} --replace-fail python3 '${python3.interpreter}'
  '';

  preConfigure = lib.optionalString stdenv.hostPlatform.isLinux ''
    buildDir="''${cmakeBuildDir:-build}"
    mkdir -p "$buildDir"
    cp ${hwdata}/share/hwdata/pci.ids "$buildDir/pci.ids"
    cp ${libdrm}/share/libdrm/amdgpu.ids "$buildDir/amdgpu.ids"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Actively maintained, feature-rich and performance oriented, neofetch like system information tool";
    homepage = "https://github.com/fastfetch-cli/fastfetch";
    changelog = "https://github.com/fastfetch-cli/fastfetch/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      defelo
      khaneliman
      luftmensch-luftmensch
    ];
    platforms = lib.platforms.all;
    mainProgram = "fastfetch";
    longDescription = ''
      Fast and highly customizable system info script.

      This unwrapped build compiles optional feature support but does not wrap
      runtime libraries into its closure.
    '';
  };
})
