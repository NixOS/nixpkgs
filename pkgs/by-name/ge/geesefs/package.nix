{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "0.43.6";
in
buildGoModule {
  pname = "geesefs";
  inherit version;

  src = fetchFromGitHub {
    owner = "yandex-cloud";
    repo = "geesefs";
    rev = "v${version}";
    hash = "sha256-FZIq58Liew5v7SGnLWmFj7nB822FAgFyCVLE9+oN9BA=";
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
