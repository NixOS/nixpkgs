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

  # tests
  nixosTests,
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
  version = "0-unstable-2025-03-05";

  src = fetchFromGitHub {
    owner = "servo";
    repo = "servo";
    rev = "69e749947910480e97ffaf22031316ebe7f67b9c";
    hash = "sha256-p06547WijlfAUgMzbCyQUFx7Xq+eUI+iB6inQguzJ1c=";
    # Breaks reproducibility depending on whether the picked commit
    # has other ref-names or not, which may change over time, i.e. with
    # "ref-names: HEAD -> main" as long this commit is the branch HEAD
    # and "ref-names:" when it is not anymore.
    postFetch = ''
      rm $out/tests/wpt/tests/tools/third_party/attrs/.git_archival.txt
    '';
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-znHKck88XXjl+v3iJFCjq0Cxyxh1HrtLbK9o3y8Kelw=";

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

  passthru = {
    updateScript = ./update.sh;
    tests = { inherit (nixosTests) servo; };
  };

  meta = {
    description = "The embeddable, independent, memory-safe, modular, parallel web rendering engine";
    homepage = "https://servo.org";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      hexa
      supinie
    ];
    mainProgram = "servo";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
