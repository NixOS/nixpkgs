{
  lib,
  buildGoModule,
  callPackage,
  fetchFromGitHub,
}:

let
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "pdtpartners";
    repo = "nix-snapshotter";
    rev = "v${version}";
    hash = "sha256-uPdgkgNV4nOKeGRH2Ucy0XlR0pVgfxvi7w55GfBVo3A=";
  };

  nix-snapshotter-lib = callPackage "${src}/package.nix" { };

in
buildGoModule {
  pname = "nix-snapshotter";
  inherit version src;
  vendorHash = "sha256-mWMkDALQ3QvDxgw1Nf0bgWYqeOFDUYKg3UNurNJdD9I=";
  passthru = { inherit (nix-snapshotter-lib) buildImage; };

  meta = {
    description = "Brings native understanding of Nix packages to containerd";
    homepage = "https://github.com/pdtpartners/nix-snapshotter";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ elpdt852 ];
  };
}
