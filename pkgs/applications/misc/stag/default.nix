<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, curses, fetchpatch }:

stdenv.mkDerivation (finalAttrs: {
  pname = "stag";
  version = "1.0.0";
=======
{ lib, stdenv, fetchFromGitHub, curses }:

stdenv.mkDerivation {
  pname = "stag";
  version = "1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "seenaburns";
    repo = "stag";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-O3iHTsaFs1l9sQV7hOoh4F+w3t28JCNlwT33zBmUP/s=";
  };

  patches = [
    # fix compilation on aarch64 https://github.com/seenaburns/stag/pull/19
    (fetchpatch {
      url = "https://github.com/seenaburns/stag/commit/0a5a8533d0027b2ee38d109adb0cb7d65d171497.diff";
      hash = "sha256-fqcsStduL3qfsp5wLJ0GLfEz0JRnOqsvpXB4gdWwVzg=";
    })
  ];

=======
    rev = "90e2964959ea8242349250640d24cee3d1966ad6";
    sha256 = "1yrzjhcwrxrxq5jj695wvpgb0pz047m88yq5n5ymkcw5qr78fy1v";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ curses ];

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = with lib; {
<<<<<<< HEAD
=======
    broken = (stdenv.isLinux && stdenv.isAarch64);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/seenaburns/stag";
    description = "Terminal streaming bar graph passed through stdin";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.unix;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
