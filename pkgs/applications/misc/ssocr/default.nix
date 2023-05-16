{ lib, stdenv, fetchFromGitHub, imlib2, libX11, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ssocr";
<<<<<<< HEAD
  version = "2.23.1";
=======
  version = "2.22.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "auerswal";
    repo = "ssocr";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-EfZsTrZI6vKM7tB6mKNGEkdfkNFbN5p4TmymOJGZRBk=";
=======
    sha256 = "sha256-j1l1o1wtVQo+G9HfXZ1sJQ8amsUQhuYxFguWFQoRe/s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ imlib2 libX11 ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Seven Segment Optical Character Recognition";
    homepage = "https://github.com/auerswal/ssocr";
    license = licenses.gpl3;
    maintainers = [ maintainers.kroell ];
  };
}
