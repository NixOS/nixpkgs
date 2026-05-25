{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "0.43.7";
in
buildGoModule {
  pname = "geesefs";
  inherit version;

  src = fetchFromGitHub {
    owner = "yandex-cloud";
    repo = "geesefs";
    rev = "v${version}";
    hash = "sha256-D9ZFjsmM4x1TVHRGcu6uredWjhwEsNjTr+kwQDmpyGE=";
  };

  # hashes differ per architecture otherwise.
  proxyVendor = true;
  vendorHash = "sha256-mvzt/pk+S7DRcU6T3fBBQw1uvluO/tfeFmONucMv7t8=";

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
