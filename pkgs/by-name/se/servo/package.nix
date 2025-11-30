{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

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
  python311,
  taplo,
  uv,
  which,
  yasm,

  # runtime deps
  fontconfig,
  freetype,
  gst_all_1,
  harfbuzz,
  libGL,
  libunwind,
  libxkbcommon,
  udev,
  vulkan-loader,
  wayland,
  xorg,
  zlib,

  # tests
  nixosTests,
}:

let
  # match .python-version
  customPython = python311.withPackages (
    ps: with ps; [
      markupsafe
      packaging
      pygments
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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "servo";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "servo";
    repo = "servo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mhZaAyLznchFUd9f2HqD7th3RDO2inH6U3L5PcZLPFA=";
    # Breaks reproducibility depending on whether the picked commit
    # has other ref-names or not, which may change over time, i.e. with
    # "ref-names: HEAD -> main" as long this commit is the branch HEAD
    # and "ref-names:" when it is not anymore.
    postFetch = ''
      rm $out/tests/wpt/tests/tools/third_party/attrs/.git_archival.txt
    '';
  };

  cargoHash = "sha256-jrspfHjJgNAzuCtFqOE7dwgMN02NwVkCOisYAOE8CrU=";

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
    rustPlatform.bindgenHook
    taplo
    uv
    which
    yasm
  ];

  env.UV_PYTHON = customPython.interpreter;

  buildInputs = [
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
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    xorg.libX11
    xorg.libxcb
    udev
    vulkan-loader
  ];

  # Builds with additional features for aarch64, see https://github.com/servo/servo/issues/36819
  buildFeatures = lib.optionals stdenv.hostPlatform.isAarch64 [
    "servo_allocator/use-system-allocator"
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    [
      # mozjs-sys fails with:
      #  cc1plus: error: '-Wformat-security' ignored without '-Wformat'
      "-Wno-error=format-security"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-I${lib.getInclude stdenv.cc.libcxx}/include/c++/v1"
    ]
  );

  # copy resources into `$out` to be used during runtime
  # link runtime libraries
  postFixup = ''
    mkdir -p $out/resources
    cp -r ./resources $out/

    wrapProgram $out/bin/servo \
      --prefix LD_LIBRARY_PATH : ${runtimePaths}
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) servo; };
  };

  meta = {
    # undefined libmozjs_sys symbols during linking
    broken = stdenv.hostPlatform.isDarwin;
    description = "Embeddable, independent, memory-safe, modular, parallel web rendering engine";
    homepage = "https://servo.org";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      hexa
      supinie
    ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "servo";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
