{ lib
, python3Packages
<<<<<<< HEAD
, fetchPypi
}:
=======
 }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "gomp";
  version = "1.1.0";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "11nq40igqbyfiygdzb1zyxx1n6d9xkv8vlmprbbi75mq54gfihhb";
  };

  doCheck = false; # tests require interactive terminal

  meta = with lib; {
    description = "A tool for comparing Git branches";
    homepage = "https://github.com/MarkForged/GOMP";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.unix;
  };
}
