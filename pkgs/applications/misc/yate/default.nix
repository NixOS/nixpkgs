<<<<<<< HEAD
{ stdenv, fetchurl, lib, openssl, pkg-config }:
=======
{ stdenv, fetchurl, lib, qt4, openssl, pkg-config }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "yate";
  version = "6.4.0-1";

  src = fetchurl {
    url = "http://voip.null.ro/tarballs/yate${lib.versions.major version}/${pname}-${version}.tar.gz";
    hash = "sha256-jCPca/+/jUeNs6hZZLUBl3HI9sms9SIPNGVRanSKA7A=";
  };

  # TODO zaptel ? postgres ?
  nativeBuildInputs = [ pkg-config ];
<<<<<<< HEAD
  buildInputs = [ openssl ];
=======
  buildInputs = [ qt4 openssl ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # /dev/null is used when linking which is a impure path for the wrapper
  postPatch =
    ''
      patchShebangs configure
      substituteInPlace configure --replace ",/dev/null" ""
    '';

  enableParallelBuilding = false; # fails to build if true

  # --unresolved-symbols=ignore-in-shared-libs makes ld no longer find --library=yate? Why?
  preBuild =
    ''
      export NIX_LDFLAGS="-L$TMP/yate $NIX_LDFLAGS"
      find . -type f -iname Makefile | xargs sed -i \
        -e 's@-Wl,--unresolved-symbols=ignore-in-shared-libs@@' \
        -e 's@-Wl,--retain-symbols-file@@'
    '';

  meta = {
    description = "Yet another telephony engine";
    homepage = "http://yate.ro/";
    # Yate's license is GPL with an exception for linking with
    # OpenH323 and PWlib (licensed under MPL).
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };

}
