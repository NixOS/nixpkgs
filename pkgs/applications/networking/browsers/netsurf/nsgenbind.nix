<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, bison
, flex
, buildsystem
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-nsgenbind";
  version = "0.8";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/nsgenbind-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-TY1TrQAK2nEncjZeanPrj8XOl1hK+chlrFsmohh/HLM=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  buildInputs = [ buildsystem ];
=======
{ lib, stdenv, fetchurl
, flex, bison
, buildsystem
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "nsgenbind";
  version = "0.8";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-TY1TrQAK2nEncjZeanPrj8XOl1hK+chlrFsmohh/HLM=";
  };

  buildInputs = [ flex bison buildsystem ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "Generator for JavaScript bindings for netsurf browser";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
=======
  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/";
    description = "Generator for JavaScript bindings for netsurf browser";
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
