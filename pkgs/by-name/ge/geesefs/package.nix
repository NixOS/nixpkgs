{ lib
, buildGoModule
, fetchFromGitHub
}:

let version = "0.41.3";
in buildGoModule {
  pname = "geesefs";
  inherit version;

  src = fetchFromGitHub {
    owner = "yandex-cloud";
    repo = "geesefs";
    rev = "v${version}";
    hash = "sha256-KdxqOkz8U8ts/pU/sTMuDIBLxwvdtrkkGptYboh06Qo=";
  };

  # hashes differ per architecture otherwise.
  proxyVendor = true;
  vendorHash = "sha256-pO6ZngGw9vp47cstOTpQ/lBpBQRXIUuSuhsldZPR5Sk=";

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
