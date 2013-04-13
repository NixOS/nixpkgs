{ stdenv, fetchgit, cmake, pkgconfig, glib, python, libgcrypt, libotr
, withIrssi ? true, irssi }:

let
  rev = "9ea5cc4e2e41";
in
with stdenv.lib;
stdenv.mkDerivation {
  name = "irssi-otr-20120915-${rev}";
  
  src = fetchgit {
    url = git://git.tuxfamily.org/gitroot/irssiotr/irssiotr.git;
    inherit rev;
    sha256 = "19zwxiy6h8n6zblqlcy6y9xyixp1yw2k8792rffsaaczjc5lpbvk";
  };

  patchPhase = ''
    cp LICENSE README irssi
  '';

  cmakeFlags = "-DIRCOTR_VERSION=mydistro-git-${rev}" +
    optionalString withIrssi " -DWANT_IRSSI=ON -DIRSSI_INCLUDE_DIR=${irssi}/include";

  nativeBuildInputs = [ python ];

  buildInputs = [ cmake pkgconfig glib libgcrypt libotr ];
  
  meta = {
    homepage = http://irssi-otr.tuxfamily.org/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
