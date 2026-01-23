{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "0.43.3";
in
buildGoModule {
  pname = "geesefs";
  inherit version;

  src = fetchFromGitHub {
    owner = "yandex-cloud";
    repo = "geesefs";
    rev = "v${version}";
    hash = "sha256-EwCWyN1wpG0CVt6vAjxNX0AYbHqblTtwKkbBIVDSJa0=";
  };

  # hashes differ per architecture otherwise.
  proxyVendor = true;
  vendorHash = "sha256-p+shpYrPxYLXpW6A4a/5qM90KH+pcMCqZOPoYTE77f0=";

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
