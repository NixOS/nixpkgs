{ lib, stdenv, fetchurl, libressl,
}:

stdenv.mkDerivation rec {
  pname = "geomyidae";
<<<<<<< HEAD
  version = "0.69";

  src = fetchurl {
    url = "gopher://bitreich.org/9/scm/geomyidae/tag/geomyidae-v${version}.tar.gz";
    hash = "sha256-C0mAjyS2wZVipXP/sKxa/d7gDyYQ/MvmwqQ/QMzmcRE=";
=======
  version = "0.51";

  src = fetchurl {
    url = "gopher://bitreich.org/9/scm/geomyidae/tag/geomyidae-v${version}.tar.gz";
    sha512 = "3lGAa7BCrspGBcQqjduBkIACpf3u/CkeSCBnaJ3rrz3OIidn4o4dNwZNe7u8swaJxN2dhDSKKeVT3RnFQUaXdg==";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ libressl ];

<<<<<<< HEAD
=======
  patches = lib.optionals stdenv.isDarwin [ ./modification-time.patch ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "A gopher daemon for Linux/BSD";
    homepage = "gopher://bitreich.org/1/scm/geomyidae";
    license = licenses.mit;
    maintainers = [ maintainers.athas ];
    platforms = platforms.unix;
  };
}
