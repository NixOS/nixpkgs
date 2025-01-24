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
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "derive_common-0.0.1" = "sha256-z0I2fQQlbUqaFU1EX45eYDy5IbZJ4SIget7WHzq4St0=";
      "fontsan-0.5.2" = "sha256-4id66xxQ8iu0+OvJKH77WYPUE0eoVa9oUHmr6lRFPa8=";
      "gilrs-0.10.6" = "sha256-RIfowFShWTPqgVWliK8Fc4cJw0YKITLvmexmTC0SwQk=";
      "mozjs-0.14.1" = "sha256-RMM28Rd0r58VLfNEJzjWw3Ze6oKEi5lC1Edv03tJbfY=";
      "peek-poke-0.3.0" = "sha256-WCZYX68vZrPhaAZwpx9/lUp3bVsLMwtmlJSW8wNb2ks=";
      "servo-media-0.1.0" = "sha256-+J/6ZJPM9eus6YHJA6ENJD63CBiJTtKZdfORq9n6Nf8=";
      "signpost-0.1.0" = "sha256-xRVXwW3Gynace9Yk5r1q7xA60yy6xhC5wLAyMJ6rPRs=";
      "webxr-0.0.1" = "sha256-HZ8oWm5BaBLBXo4dS2CbWjpExry7dzeB2ddRLh7+98w=";
      "naga-22.0.0" = "sha256-Xi2lWZCv4V2mUbQmwV1aw3pcvIIcyltKvv/C+LVqqDI=";
      "raqote-0.8.5" = "sha256-WLsz5q08VNmYBxUhQ0hOn0K0RVFnnjaWF/MuQGkO/Rg=";
    };
  };

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
    rustPlatform.bindgenHook
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

  meta = {
    description = "The embeddable, independent, memory-safe, modular, parallel web rendering engine";
    homepage = "https://servo.org";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ supinie ];
    mainProgram = "servo";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
