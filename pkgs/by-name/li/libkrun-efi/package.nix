{
  cargo,
  fetchFromGitHub,
  fetchurl,
  lib,
  libepoxy,
  moltenvk,
  pkg-config,
  rustc,
  rustPlatform,
  rutabaga_gfx,
  stdenv,
  virglrenderer,
  vulkan-headers,
  withGpu ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libkrun-efi";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iFPJnv86wb0hU4QngdCCXP9cOpspDNVM8yFgS0XMdqg=";
  };

  outputs = [
    "out"
    "dev"
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-lDyY7InY3cUnbMg0Gw2oUL/xZOMCJD0tp1/Q9UdENR0=";
  };

  nativeBuildInputs = [
    cargo
    pkg-config
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libepoxy
    rutabaga_gfx
    (virglrenderer.overrideAttrs {
      version = "0.10.4d";
      src = fetchurl {
        url = "https://gitlab.freedesktop.org/slp/virglrenderer/-/archive/0.10.4d-krunkit/virglrenderer-0.10.4d-krunkit.tar.bz2";
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
    })
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "EFI=1"
  ] ++ lib.optional withGpu "GPU=1";

  postInstall = ''
    mkdir -p $dev/lib
    mv $out/lib/pkgconfig $dev/lib
    mv $out/include $dev
  '';

  meta = with lib; {
    description = "EFI variant of Libkrun, a dynamic library providing Virtualization-based process isolation capabilities";
    homepage = "https://github.com/containers/libkrun";
    license = licenses.asl20;
    maintainers = with maintainers; [ quinneden ];
    platforms = [ "aarch64-darwin" ];
  };
})
