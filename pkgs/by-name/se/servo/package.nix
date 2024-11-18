{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # build deps
  cargo-deny,
  cmake,
  dbus,
  gcc,
  git,
  gnumake,
  libxkbcommon,
  llvm,
  llvmPackages,
  m4,
  makeWrapper,
  perl,
  pkg-config,
  python3,
  taplo,
  vulkan-loader,
  which,
  yasm,
  zlib,

  # runtime deps
  darwin,
  fontconfig,
  freetype,
  gst_all_1,
  libGL,
  libunwind,
  udev,
  wayland,
  xorg,
}:

let
  customPython = python3.withPackages (
    ps: with ps; [
      dbus
      packaging
      pip
      six
      virtualenv
    ]
  );
  runtimePaths = lib.makeLibraryPath [
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    libxkbcommon
    vulkan-loader
    wayland
    libGL
  ];
in

rustPlatform.buildRustPackage {
  pname = "servo";
  version = "0-unstable-2024-09-09";

  src = fetchFromGitHub {
    owner = "servo";
    repo = "servo";
    rev = "938fd8c12fc2489303e12538d3e3585bd771141f";
    hash = "sha256-CrpEBFYd8Qd0rxSnT81IvtxxEuYG0jWGJeHISvxalyY=";
  };

  # need to use a `Cargo.lock` as there are git dependencies
  useFetchCargoVendor = true;
  cargoHash = "sha256-cvc1l2b2MZvKdEyxP3DsSyF5eZ3zgj+H/zw80O3NLDQ=";

  # Remap absolute path between modules to include SEMVER
  # set `HOME` to a temp dir for write access
  # Fix invalid option errors during linking (https://github.com/mozilla/nixpkgs-mozilla/commit/c72ff151a3e25f14182569679ed4cd22ef352328)
  preConfigure = ''
    sed -i -e 's/\/style\//\/style-0.0.1\//g' ../cargo-vendor-dir/servo_atoms-0.0.1/build.rs
    export HOME=$TMPDIR
    unset AS
  '';

  nativeBuildInputs = [
    cargo-deny
    cmake
    customPython
    dbus
    gcc
    git
    gnumake
    llvm
    llvmPackages.libstdcxxClang
    m4
    makeWrapper
    perl
    pkg-config
    python3
    taplo
    which
    yasm
    zlib
  ];

  buildInputs = [
    fontconfig
    freetype
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    libunwind
    udev
    wayland
    libGL
    xorg.libX11
    xorg.libxcb
  ] ++ (lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.AppKit ]);

  # copy resources into `$out` to be used during runtime
  # link runtime libraries
  postFixup = ''
    mkdir -p $out/resources
    cp -r ./resources $out/

    wrapProgram $out/bin/servo \
      --prefix LD_LIBRARY_PATH : ${runtimePaths}
  '';

  LIBCLANG_PATH = "${lib.getLib llvmPackages.libclang}/lib";

  meta = {
    description = "The embeddable, independent, memory-safe, modular, parallel web rendering engine";
    homepage = "https://servo.org";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ supinie ];
    mainProgram = "servo";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
