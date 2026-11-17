{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  freefont_ttf,
  spice-protocol,
  nettle,
  libbfd,
  fontconfig,
  libffi,
  expat,
  libGL,
  nanosvg,
  fuse3,
  usbredir,

  libx11,
  libxkbcommon,
  libxext,
  libxrandr,
  libxi,
  libxscrnsaver,
  libxinerama,
  libxcursor,
  libxpresent,
  libxdmcp,

  wayland,
  wayland-protocols,
  wayland-scanner,

  pipewire,
  pulseaudio,
  libsamplerate,

  libunwind,
  elfutils,
  libdecor,

  xorgSupport ? true,
  waylandSupport ? true,
  pipewireSupport ? true,
  pulseSupport ? true,
  backtraceSupport ? true,
  libdecorSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "looking-glass-client";
  version = "B8-rc1";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = finalAttrs.version;
    hash = "sha256-ropEJC9+Gg85DS9XRuTb2IRGNNmUcA09Sy/cN6DTvZE=";
    fetchSubmodules = true;
  };

  patches = [
    ./nanosvg-unvendor.diff
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libxkbcommon
    libGL
    freefont_ttf
    spice-protocol
    expat
    libbfd
    nettle
    fontconfig
    libffi
    nanosvg
    fuse3
    usbredir
  ]
  ++ lib.optionals xorgSupport [
    libx11
    libxi
    libxscrnsaver
    libxinerama
    libxcursor
    libxpresent
    libxext
    libxrandr
    libxdmcp
  ]
  ++ lib.optionals waylandSupport [
    wayland
    wayland-protocols
  ]
  ++ lib.optionals pipewireSupport [
    pipewire
    libsamplerate
  ]
  ++ lib.optionals pulseSupport [
    pulseaudio
    libsamplerate
  ]
  ++ lib.optionals backtraceSupport [
    libunwind
    elfutils
  ]
  ++ lib.optionals libdecorSupport [
    libdecor
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeFeature "OPTIMIZE_FOR_NATIVE" "OFF")
    (lib.cmakeBool "ENABLE_EGL" true)
    (lib.cmakeBool "ENABLE_OPENGL" false) # "legacy"
    (lib.cmakeBool "ENABLE_PIPEWIRE" pipewireSupport)
    (lib.cmakeBool "ENABLE_PULSEAUDIO" pulseSupport)
    (lib.cmakeBool "ENABLE_X11" xorgSupport)
    (lib.cmakeBool "ENABLE_WAYLAND" waylandSupport)
    (lib.cmakeBool "ENABLE_BACKTRACE" backtraceSupport)
    (lib.cmakeBool "ENABLE_USB_AUDIO" true)
    (lib.cmakeBool "ENABLE_LIBDECOR" libdecorSupport)
  ];

  postUnpack = ''
    echo ${finalAttrs.src.rev} > source/VERSION
    export sourceRoot="source/client"
  '';

  postInstall = ''
    mkdir -p $out/share/pixmaps
    cp $src/resources/lg-logo.png $out/share/pixmaps
  '';

  meta = {
    description = "KVM Frame Relay (KVMFR) implementation";
    longDescription = ''
      Looking Glass is an open source application that allows the use of a KVM
      (Kernel-based Virtual Machine) configured for VGA PCI Pass-through
      without an attached physical monitor, keyboard or mouse. This is the final
      step required to move away from dual booting with other operating systems
      for legacy programs that require high performance graphics.
    '';
    homepage = "https://looking-glass.io/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "looking-glass-client";
    maintainers = with lib.maintainers; [
      alexbakker
      babbaj
      j-brn
    ];
    platforms = [ "x86_64-linux" ];
  };
})
