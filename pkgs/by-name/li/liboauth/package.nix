{
  fetchurl,
  lib,
  stdenv,
  nss,
  nspr,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "liboauth";
  version = "1.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/liboauth/${pname}-${version}.tar.gz";
    sha256 = "07w1aq8y8wld43wmbk2q8134p3bfkp2vma78mmsfgw2jn1bh3xhd";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [
    nss
    nspr
  ];

  configureFlags = [ "--enable-nss" ];

  postInstall = ''
    substituteInPlace $out/lib/liboauth.la \
      --replace "-lnss3" "-L${nss.out}/lib -lnss3"
  '';

<<<<<<< HEAD
  meta = {
    platforms = lib.platforms.all;
    description = "C library implementing the OAuth secure authentication protocol";
    homepage = "http://liboauth.sourceforge.net/";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    platforms = platforms.all;
    description = "C library implementing the OAuth secure authentication protocol";
    homepage = "http://liboauth.sourceforge.net/";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

}
