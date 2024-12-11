{
  lib,
  stdenv,
  fetchgit,
  fetchpatch,
  cargo,
  pkg-config,
  rustPlatform,
  aemu,
  gfxstream,
  libdrm,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rutabaga_gfx";
  version = "0.1.2";

  src = fetchgit {
    url = "https://chromium.googlesource.com/crosvm/crosvm";
    rev = "v${finalAttrs.version}-rutabaga-release";
    fetchSubmodules = true;
    hash = "sha256-0RJDKzeU7U6hc6CLKks8QcRs3fxN+/LYUbB0t6W790M=";
  };

  patches = [
    # Make gfxstream optional
    # https://chromium-review.googlesource.com/c/crosvm/crosvm/+/4860836
    (fetchpatch {
      url = "https://chromium.googlesource.com/crosvm/crosvm/+/c3ad0e43eb12cbf737a6049e0134d483e337363f%5E%21/?format=TEXT";
      decode = "base64 -d";
      hash = "sha256-Ji1bK7jnRlg0OpDfCLcTHfPSiz3zYcdgsWL4n3EoIYI=";
    })
    # Fix error in Makefile where it uses eight spaces instead of a tab
    # https://chromium-review.googlesource.com/c/crosvm/crosvm/+/4863380
    (fetchpatch {
      url = "https://chromium.googlesource.com/crosvm/crosvm/+/fc415bccc43d36f63a2fd4c28878591bb1053450%5E%21/?format=TEXT";
      decode = "base64 -d";
      hash = "sha256-SLzlZ4o1+R2bGTPvA0a5emq97hOIIIHrubFhcQjqYwg=";
    })
    # Install the dylib on Darwin.
    ./darwin-install.patch
  ];

  nativeBuildInputs = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
  ];
  buildInputs =
    [ libiconv ]
    ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform gfxstream) (
      [
        aemu
        gfxstream
      ]
      ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform libdrm) [
        libdrm
      ]
    );

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-wuF3Isrp+u5J8jPQoPsIOWYGNKLSNa2pLfvladAWkLs=";
  };

  CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;
  "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_LINKER" = "${stdenv.cc.targetPrefix}cc";

  postConfigure = ''
    cd rutabaga_gfx/ffi
    substituteInPlace Makefile --replace-fail pkg-config "$PKG_CONFIG"
  '';

  # make install always rebuilds
  dontBuild = true;

  makeFlags = [
    "prefix=$(out)"
    "OUT=target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ];

  meta = with lib; {
    homepage = "https://crosvm.dev/book/appendix/rutabaga_gfx.html";
    description = "cross-platform abstraction for GPU and display virtualization";
    license = licenses.bsd3;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.darwin ++ platforms.linux;
  };
})
