{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  nss,
  nspr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svrcore";
  version = "4.0.4";

  src = fetchurl {
    url = "mirror://mozilla/directory/svrcore/releases/${finalAttrs.version}/src/svrcore-${finalAttrs.version}.tar.bz2";
    sha256 = "0n3alg6bxml8952fb6h0bi0l29farvq21q6k20gy2ba90m3znwj7";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    nss
    nspr
  ];

  meta = {
    description = "Secure PIN handling using NSS crypto";
    license = lib.licenses.mpl11;
    platforms = lib.platforms.all;
  };
})
