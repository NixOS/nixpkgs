{
  lib,
  stdenv,
  fetchurl,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "getxbook";
  version = "1.2";

  src = fetchurl {
    url = "https://njw.me.uk/getxbook/getxbook-${finalAttrs.version}.tar.xz";
    sha256 = "0ihwrx4gspj8l7fc8vxch6dpjrw1lvv9z3c19f0wxnmnxhv1cjvs";
  };

  env.NIX_CFLAGS_COMPILE = toString (
    [ "-Wno-error=deprecated-declarations" ]
    ++ lib.optionals (!stdenv.cc.isClang) [
      "-Wno-error=format-truncation"
      "-Wno-error=stringop-overflow"
    ]
  );

  buildInputs = [ openssl ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Collection of tools to download books from Google Books";
    homepage = "https://njw.me.uk/getxbook/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ obadz ];
    platforms = lib.platforms.all;
  };
})
