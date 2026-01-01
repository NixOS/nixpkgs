{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  pkg-config,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "libp11";
  version = "0.4.13";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "libp11";
    rev = "${pname}-${version}";
<<<<<<< HEAD
    sha256 = "sha256-xH5Ic8HpWB5O2MWXf2A9FUiV10VZajDdPqEVF0Hs6u0=";
=======
    sha256 = "sha256-teYXlPtCt6ifQDArbCJWGrYl9pdr6V7HVpU4HXTPIco=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  configureFlags = [
    "--with-enginesdir=${placeholder "out"}/lib/engines"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    libtool
  ];

  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  passthru = { inherit openssl; };

<<<<<<< HEAD
  meta = {
    description = "Small layer on top of PKCS#11 API to make PKCS#11 implementations easier";
    homepage = "https://github.com/OpenSC/libp11";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Small layer on top of PKCS#11 API to make PKCS#11 implementations easier";
    homepage = "https://github.com/OpenSC/libp11";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
