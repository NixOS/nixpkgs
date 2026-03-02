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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "krunkit";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "krunkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2O2v4etlXN61f8Goog+/e/6FTCtt7xSJnkq+w2KGxUM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-ckUunlnyf5BXq/EzFYPF8fI996/NgQaXUuVdOgfj1yk=";
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
    libkrun-efi
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  # This is necessary in order for the binary to keep its entitlements
  dontStrip = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Launch configurable virtual machines with libkrun";
    homepage = "https://github.com/containers/krunkit";
    license = lib.licenses.asl20;
    platforms = [ "aarch64-darwin" ];
    maintainers = with lib.maintainers; [ quinneden ];
  };
})
