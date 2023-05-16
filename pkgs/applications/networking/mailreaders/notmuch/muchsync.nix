{ lib, stdenv, fetchurl
, notmuch, openssl, pkg-config, sqlite, xapian, zlib
}:
stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "7";
=======
  version = "6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "muchsync";
  passthru = {
    inherit version;
  };
  src = fetchurl {
    url = "http://www.muchsync.org/src/${pname}-${version}.tar.gz";
<<<<<<< HEAD
    hash = "sha256-+D4vb80O9IE0df3cjTkoVoZlTaX0FWWh6ams14Gjvqw=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ notmuch openssl sqlite xapian zlib ];
  XAPIAN_CONFIG = "${xapian}/bin/xapian-config";
=======
    sha256 = "Cz3jtNiF7bn4h6B9y8i1luf+8gOMYeaCz6VaE/pM6eg=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ notmuch openssl sqlite xapian zlib ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = {
    description = "Synchronize maildirs and notmuch databases";
    homepage = "http://www.muchsync.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [];
    license = lib.licenses.gpl2Plus;
  };
}
