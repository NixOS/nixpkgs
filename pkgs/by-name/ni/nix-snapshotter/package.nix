{
  lib,
  buildGoModule,
  callPackage,
  fetchFromGitHub,
}:

let
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "pdtpartners";
    repo = "nix-snapshotter";
    rev = "v${version}";
    hash = "sha256-nrY/S0wJM3aQcZpPNYTy/kHaBCg5y6/O+gZNHIWVTRQ=";
  };

  nix-snapshotter-lib = callPackage "${src}/package.nix" { };

in
buildGoModule {
  pname = "nix-snapshotter";
  inherit version src;
  vendorHash = "sha256-QBLePOnfsr6I19ddyZNSFDih6mCaZ/NV2Qz1B1pSHxs=";
  passthru = { inherit (nix-snapshotter-lib) buildImage; };

  meta = {
    description = "Brings native understanding of Nix packages to containerd";
    homepage = "https://github.com/pdtpartners/nix-snapshotter";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ elpdt852 ];
  };
}
