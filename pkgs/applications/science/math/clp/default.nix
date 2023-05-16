{ lib, stdenv, fetchFromGitHub, pkg-config, coin-utils, zlib, osi }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "1.17.8";
=======
  version = "1.17.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "clp";
  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Clp";
    rev = "releases/${version}";
<<<<<<< HEAD
    hash = "sha256-3Z6ysoCcDVB8UePiwbZNqvO/o/jgPcv6XFkpJZBK+Os=";
=======
    hash = "sha256-CfAK/UbGaWvyk2ZxKEgziVruzZfz7WMJVi/YvdR/UNA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ zlib coin-utils osi ];

  doCheck = true;

  meta = with lib; {
    license = licenses.epl20;
    homepage = "https://github.com/coin-or/Clp";
    description = "An open-source linear programming solver written in C++";
    platforms = platforms.darwin ++ [ "x86_64-linux" ];
    maintainers = [ maintainers.vbgl ];
  };
}
