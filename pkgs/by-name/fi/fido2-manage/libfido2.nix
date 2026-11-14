{
  lib,
  stdenv,
  libfido2,
  fetchurl,
  src,
}:
# Upstream's CCID transport and JSON extensions target libfido2 1.15.0.
libfido2.overrideAttrs (oldAttrs: {
  pname = "libfido2-token2";
  version = "1.15.0";

  src = fetchurl {
    url = "https://developers.yubico.com/libfido2/Releases/libfido2-1.15.0.tar.gz";
    hash = "sha256-q6qxMY0h0mLs5Bb7inEy+pN0vaifb6UrhqmKL1cSth4=";
  };

  patches = [
    "${src}/libfido2-token2.patch"
    "${src}/libfido2-json.patch"
  ];

  cmakeFlags = oldAttrs.cmakeFlags ++ lib.optional stdenv.hostPlatform.isDarwin "-DUSE_PCSC=ON";
})
