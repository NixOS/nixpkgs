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
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "libkrun";
    repo = "krunkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-43XqNofzKi310nhxTNo/Gj5didVa/u/gV05hglecLtk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-Yb2jyK4UBJCeVXSKl4UABnlMj+7SKpOIi49tD/itHYo=";
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
