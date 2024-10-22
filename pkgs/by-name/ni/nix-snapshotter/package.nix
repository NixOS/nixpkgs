{ lib
, buildGoModule
, callPackage
, fetchFromGitHub
}:

let
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "pdtpartners";
    repo = "nix-snapshotter";
    rev = "v${version}";
    hash = "sha256-hQ2b9Yx8g8okVWGo/iuvY2sR6FWI8iKp74m4gdXeueI=";
  };

  nix-snapshotter-lib = callPackage "${src}/package.nix" {};

in buildGoModule {
  pname = "nix-snapshotter";
  inherit version src;
  vendorHash = "sha256-QBLePOnfsr6I19ddyZNSFDih6mCaZ/NV2Qz1B1pSHxs=";
  passthru = { inherit (nix-snapshotter-lib) buildImage; };

  meta = {
    description = "Brings native understanding of Nix packages to containerd";
    homepage    = "https://github.com/pdtpartners/nix-snapshotter";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ elpdt852 ];
  };
}
