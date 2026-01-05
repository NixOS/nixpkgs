{
  lib,
  stdenv,
  fetchgit,
  cargo,
  meson,
  ninja,
  pkg-config,
  rustc,
  rustPlatform,
  aemu,
  gfxstream,
  libdrm,
  libiconv,
  withGfxstream ? lib.meta.availableOn stdenv.hostPlatform gfxstream,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rutabaga_gfx";
  version = "0.1.6";

  src = fetchgit {
    url = "https://chromium.googlesource.com/crosvm/crosvm";
    rev = "v${finalAttrs.version}-rutabaga-release";
    fetchSubmodules = true;
    hash = "sha256-/zeWWL4Mdb/kIJ0J3nky5dastsZUOXm9YTXUjKCDJcY=";
  };

  separateDebugInfo = true;

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
  ];
  buildInputs = [
    libiconv
  ]
  ++ lib.optionals withGfxstream (
    [
      aemu
      gfxstream
    ]
    ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform libdrm) [
      libdrm
    ]
  );

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-23F0WU//4xvP9xffxr+cQa0m0sSJjcWyz+usKBpDg20=";
  };

  mesonFlags = [
    (lib.mesonBool "gfxstream" withGfxstream)
  ];

  CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;
  "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_LINKER" = "${stdenv.cc.targetPrefix}cc";

  preConfigure = ''
    cd rutabaga_gfx/ffi
    chmod +x build.sh
    patchShebangs build.sh
    substituteInPlace build.sh \
      --replace-fail '"$BUILDTYPE"/"$SHARED_LIB"' '${stdenv.hostPlatform.rust.cargoShortTarget}/"$BUILDTYPE"/"$SHARED_LIB"'
  '';

  meta = with lib; {
    homepage = "https://crosvm.dev/book/appendix/rutabaga_gfx.html";
    description = "Cross-platform abstraction for GPU and display virtualization";
    license = licenses.bsd3;
    maintainers = with maintainers; [ qyliss ];
    platforms = [
      # src/generated/virgl_debug_callback_bindings.rs
      "aarch64-darwin"
      "aarch64-linux"
      "armv5tel-linux"
      "armv6l-linux"
      "armv7a-linux"
      "armv7l-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
})
