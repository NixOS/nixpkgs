{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # build deps
  cargo-deny,
  cmake,
  dbus,
  git,
  gnumake,
  llvm,
  llvmPackages,
  m4,
  makeWrapper,
  perl,
  pkg-config,
  python3,
  taplo,
  which,
  yasm,
  zlib,

  # runtime deps
  apple-sdk_14,
  fontconfig,
  freetype,
  gst_all_1,
  harfbuzz,
  libcxx,
  libGL,
  libunwind,
  libxkbcommon,
  udev,
  vulkan-loader,
  wayland,
  xorg,
}:

let
  customPython = python3.withPackages (
    ps: with ps; [
      packaging
    ]
  );
  runtimePaths = lib.makeLibraryPath (
    lib.optionals (stdenv.hostPlatform.isLinux) [
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXi
      libxkbcommon
      vulkan-loader
      wayland
      libGL
    ]
  );
in

rustPlatform.buildRustPackage {
  pname = "servo";
  version = "0-unstable-2025-01-14";

  src = fetchFromGitHub {
    owner = "servo";
    repo = "servo";
    rev = "f5ef8aaed32e6a6da3faca3a710e73cd35c31059";
    hash = "sha256-LaAg07Lp/oWNsrtqM6UrqmPAm/ajmPJPZb5O7q9eLO8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-a5Dv/AiPs/fnKcboBej9H7BiRKCIjm0GaQ2ICiH9SpQ=";

  postPatch = ''
    # Remap absolute path between modules to include SEMVER
    substituteInPlace ../servo-0-unstable-*-vendor/servo_atoms-0.0.1/build.rs --replace-fail \
      "../style/counter_style/predefined.rs" \
      "../style-0.0.1/counter_style/predefined.rs"
  '';

  # set `HOME` to a temp dir for write access
  # Fix invalid option errors during linking (https://github.com/mozilla/nixpkgs-mozilla/commit/c72ff151a3e25f14182569679ed4cd22ef352328)
  preConfigure = ''
    export HOME=$TMPDIR
    unset AS
  '';

  nativeBuildInputs = [
    cargo-deny
    cmake
    customPython
    dbus
    git
    gnumake
    llvm
    llvmPackages.libstdcxxClang
    m4
    makeWrapper
    perl
    pkg-config
    python3
    rustPlatform.bindgenHook
    taplo
    which
    yasm
    zlib
  ];

  buildInputs =
    [
      fontconfig
      freetype
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      harfbuzz
      libunwind
      libGL
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      wayland
      xorg.libX11
      xorg.libxcb
      udev
      vulkan-loader
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_14
      libcxx
    ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-I${lib.getDev libcxx}/include/c++/v1";

  # copy resources into `$out` to be used during runtime
  # link runtime libraries
  postFixup = ''
    mkdir -p $out/resources
    cp -r ./resources $out/

    wrapProgram $out/bin/servo \
      --prefix LD_LIBRARY_PATH : ${runtimePaths}
  '';

  meta = {
    description = "The embeddable, independent, memory-safe, modular, parallel web rendering engine";
    homepage = "https://servo.org";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ supinie ];
    mainProgram = "servo";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
