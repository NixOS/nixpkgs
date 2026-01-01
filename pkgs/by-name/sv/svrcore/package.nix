{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  nss,
  nspr,
}:

stdenv.mkDerivation rec {
  pname = "svrcore";
  version = "4.0.4";

  src = fetchurl {
    url = "mirror://mozilla/directory/svrcore/releases/${version}/src/${pname}-${version}.tar.bz2";
    sha256 = "0n3alg6bxml8952fb6h0bi0l29farvq21q6k20gy2ba90m3znwj7";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    nss
    nspr
  ];

<<<<<<< HEAD
  meta = {
    description = "Secure PIN handling using NSS crypto";
    license = lib.licenses.mpl11;
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Secure PIN handling using NSS crypto";
    license = licenses.mpl11;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
