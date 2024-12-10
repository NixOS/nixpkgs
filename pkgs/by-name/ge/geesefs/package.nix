{ lib
, buildGoModule
, fetchFromGitHub
}:

let version = "0.42.3";
in buildGoModule {
  pname = "geesefs";
  inherit version;

  src = fetchFromGitHub {
    owner = "yandex-cloud";
    repo = "geesefs";
    rev = "v${version}";
    hash = "sha256-keF6KrkHI5sIm5XCIpWAvKD1qu5XvWx3uR70eKhOZk8=";
  };

  # hashes differ per architecture otherwise.
  proxyVendor = true;
  vendorHash = "sha256-SQgYB6nLSnqKUntWGJL+dQD+cAPQ69Rjdq1GXIt21xg=";

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
