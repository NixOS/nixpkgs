{
  cargo,
  darwin,
  pkg-config,
  rustc,
  stdenv,
  fetchFromGitHub,
  libepoxy,
  libkrun-efi,
  rustPlatform,
  lib,
  nix-update-script,
  withGpu ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "krunkit";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "krunkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fyk3vF/d+qv347XI1+z7zzd5JxRRjopnKIV6GATA3Ac=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-4WLmIlk2OSmIt9FPDjCPHD5JyBszCWMwVEhbnnKKNQY=";
  };

  nativeBuildInputs = [
    cargo
    darwin.sigtool
    pkg-config
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libepoxy
    (libkrun-efi.override { inherit withGpu; })
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  dontStrip = true;

  meta = {
    description = "Launch configurable virtual machines with libkrun";
    homepage = "https://github.com/containers/krunkit";
    license = lib.licenses.asl20;
    platforms = [ "aarch64-darwin" ];
    maintainers = with lib.maintainers; [ quinneden ];
  };

  passthru = {
    tests.withGpu = libkrun-efi.override { withGpu = false; };
    updateScript = nix-update-script { };
  };
})
