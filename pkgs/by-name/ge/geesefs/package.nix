{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "0.42.0";
in
buildGoModule {
  pname = "geesefs";
  inherit version;

  src = fetchFromGitHub {
    owner = "yandex-cloud";
    repo = "geesefs";
    rev = "v${version}";
    hash = "sha256-bScx+4g1g4mE2l8nCWVZz/QT8jKOOpksqMmlTDp+DsA=";
  };

  # hashes differ per architecture otherwise.
  proxyVendor = true;
  vendorHash = "sha256-50ND58TuEilORX24qRSfWlO2A1fkCakm16UPOCse11E=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/yandex-cloud/geesefs";
    description = "Finally, a good FUSE FS implementation over S3";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.flokli ];
    platforms = lib.platforms.unix;
    mainProgram = "geesefs";
  };
}
