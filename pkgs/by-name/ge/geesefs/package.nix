{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "0.43.9";
in
buildGoModule {
  pname = "geesefs";
  inherit version;

  src = fetchFromGitHub {
    owner = "yandex-cloud";
    repo = "geesefs";
    rev = "v${version}";
    hash = "sha256-hvuDQATjSyMUVne/x9STEAMaiZz1wswTH8dvKSdtBEI=";
  };

  # hashes differ per architecture otherwise.
  proxyVendor = true;
  vendorHash = "sha256-VwqpiWdUa32dkoltgGxk+3hV9y6z6B0szIaWNLSx3Rs=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/yandex-cloud/geesefs";
    description = "Finally, a good FUSE FS implementation over S3";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.flokli ];
    platforms = lib.platforms.unix;
    mainProgram = "geesefs";
  };
}
