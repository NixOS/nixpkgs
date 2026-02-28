{
  cargo,
  fetchFromGitHub,
  fetchurl,
  fixDarwinDylibNames,
  lib,
  libepoxy,
  libkrun-efi,
  moltenvk,
  pkg-config,
  buildPackages,
  rustc,
  rustPlatform,
  rutabaga_gfx,
  nix-update-script,
  stdenv,
  meson,
  ninja,
  vulkan-headers,
  withGpu ? true,
}:
let
  version = "1.17.4";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrun";
    tag = "v${version}";
    hash = "sha256-Th4vCg3xHb6lbo26IDZES7tLOUAJTebQK2+h3xSYX7U=";
  };

  virglrenderer = stdenv.mkDerivation (finalAttrs: {
    pname = "virglrenderer";
    version = "0.10.4d-krunkit";

    src = fetchurl {
      url = "https://gitlab.freedesktop.org/slp/virglrenderer/-/archive/${finalAttrs.version}/virglrenderer-${finalAttrs.version}.tar.bz2";
      hash = "sha256-M/buj97QUeY6CYeW0VICD5F6FBPi9ATPGHpNA48xL3o=";
    };

    separateDebugInfo = true;

    buildInputs = [
      libepoxy
      moltenvk
      vulkan-headers
    ];

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
      (buildPackages.python3.withPackages (ps: [ ps.pyyaml ]))
    ];

    mesonFlags = [
      (lib.mesonBool "render-server" false)
      (lib.mesonBool "venus" true)
      (lib.mesonEnable "drm" false)
    ];

    meta = {
      description = "Virtual 3D GPU library that allows a qemu guest to use the host GPU for accelerated 3D rendering";
      mainProgram = "virgl_test_server";
      homepage = "https://gitlab.freedesktop.org/slp/virglrenderer";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = [ lib.maintainers.quinneden ];
    };
  });

  initBinary = buildPackages.pkgsCross.aarch64-multiplatform.pkgsStatic.stdenv.mkDerivation {
    pname = "libkrun-init";
    inherit version src;

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild
      cd init
      $CC -O2 -static -Wall -o init init.c
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -D init $out/init
      runHook postInstall
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libkrun-efi";
  inherit version src;

  outputs = [
    "out"
    "dev"
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-0xpAyNe1jF1OMtc7FXMsejqIv0xKc1ktEvm3rj/mVFU=";
  };

  nativeBuildInputs = [
    cargo
    fixDarwinDylibNames
    pkg-config
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libepoxy
    rutabaga_gfx
    virglrenderer
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "EFI=1"
  ]
  ++ lib.optional withGpu "GPU=1";

  preBuild = ''
    cp ${initBinary}/init init/init
  '';

  passthru = {
    tests.withoutGpu = libkrun-efi.override { withGpu = false; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "EFI variant of Libkrun, a dynamic library providing Virtualization-based process isolation capabilities";
    homepage = "https://github.com/containers/libkrun";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ quinneden ];
    platforms = [ "aarch64-darwin" ];
  };
})
