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
  rustc,
  rustPlatform,
  rutabaga_gfx,
  nix-update-script,
  stdenv,
  virglrenderer,
  vulkan-headers,
  withGpu ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libkrun-efi";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tXF1AkcwSBj+e3qEGR/NqB1U+y4+MIRbaL9xB0cZQbQ=";
  };

  outputs = [
    "out"
    "dev"
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-IrJVP7I8NDB4KyZ0g8D6Tx+dT+lN8Yg8uRT9tXlL/8s=";
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
    (virglrenderer.overrideAttrs (
      finalAttrs: _: {
        version = "0.10.4d";
        src = fetchurl {
          url = "https://gitlab.freedesktop.org/slp/virglrenderer/-/archive/${finalAttrs.version}-krunkit/virglrenderer-${finalAttrs.version}-krunkit.tar.bz2";
          hash = "sha256-M/buj97QUeY6CYeW0VICD5F6FBPi9ATPGHpNA48xL3o=";
        };
        buildInputs = [
          libepoxy
          moltenvk.dev
          vulkan-headers
        ];
        mesonFlags = [
          (lib.mesonBool "venus" true)
          (lib.mesonBool "render-server" false)
          (lib.mesonEnable "drm" false)
        ];
      }
    ))
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "EFI=1"
  ]
  ++ lib.optional withGpu "GPU=1";

  postInstall = ''
    mkdir -p $dev/lib
    mv $out/lib/pkgconfig $dev/lib
    mv $out/include $dev
  '';

  meta = {
    description = "EFI variant of Libkrun, a dynamic library providing Virtualization-based process isolation capabilities";
    homepage = "https://github.com/containers/libkrun";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ quinneden ];
    platforms = [ "aarch64-darwin" ];
  };

  passthru = {
    tests.withGpu = libkrun-efi.override { withGpu = false; };
    updateScript = nix-update-script { };
  };
})
