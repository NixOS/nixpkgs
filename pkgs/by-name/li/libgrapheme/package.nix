{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "libgrapheme";
<<<<<<< HEAD
  version = "3.0.0";

  src = fetchurl {
    url = "https://dl.suckless.org/libgrapheme/libgrapheme-${version}.tar.gz";
    hash = "sha256-Mlha9z3aYvvMD+0U8ZmqG8mIrQHa0L+9Bs8XXZzz1ow=";
=======
  version = "2.0.2";

  src = fetchurl {
    url = "https://dl.suckless.org/libgrapheme/libgrapheme-${version}.tar.gz";
    hash = "sha256-pou93edr1Vul1kEWzl5CoT3wRcgcCFLemrYIlqoUMSU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace configure \
      --replace-fail "uname" "echo ${stdenv.hostPlatform.uname.system}"
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  makeFlags = [
    "AR:=$(AR)"
    "CC:=$(CC)"
    "RANLIB:=$(RANLIB)"
    "BUILD_CC=$(CC_FOR_BUILD)"
  ];

  installFlags = [
    "PREFIX=$(out)"
    "LDCONFIG="
  ];

<<<<<<< HEAD
  meta = {
    description = "Unicode string library";
    homepage = "https://libs.suckless.org/libgrapheme/";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sikmir ];
=======
  meta = with lib; {
    description = "Unicode string library";
    homepage = "https://libs.suckless.org/libgrapheme/";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
