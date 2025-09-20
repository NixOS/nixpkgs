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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "krunkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dsEZZiLgHyd6xeXZCdDd4zsxzwQeIhAK+lewY2ZfvpY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-i0cC3aOEqcvOcwTPbM6AazMzd8Q+QLwuhnvPGv3ntsc=";
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

  passthru = {
    tests.withoutGpu = libkrun-efi.override { withGpu = false; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Launch configurable virtual machines with libkrun";
    homepage = "https://github.com/containers/krunkit";
    license = lib.licenses.asl20;
    platforms = [ "aarch64-darwin" ];
    maintainers = with lib.maintainers; [ quinneden ];
  };
})
