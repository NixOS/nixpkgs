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
  withGpu ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "krunkit";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "krunkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iOd4UjmSrVuJPvWwP8GV2DWYsTWAXAXguXK4VxiDOko=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-9a76zZQqYoEVhh2rAysMLKA+dfjhtAFx5qXQkyCA8d0=";
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

  passthru.updateScript = nix-update-script { };
})
