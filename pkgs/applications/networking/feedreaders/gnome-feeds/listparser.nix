{ lib
, python3
<<<<<<< HEAD
, fetchPypi
}:

=======
}:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
python3.pkgs.buildPythonPackage rec {
  pname = "listparser";
  version = "0.18";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3.pkgs.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "0hdqs1mmayw1r8yla43hgb4d9y3zqs5483vgf8j9ygczkd2wrq2b";
  };

  propagatedBuildInputs = with python3.pkgs; [
    requests
    six
  ];

  checkPhase = ''
    ${python3.interpreter} lptest.py
  '';

  meta = with lib; {
    description = "A parser for subscription lists";
    homepage = "https://github.com/kurtmckee/listparser";
    license = licenses.lgpl3Plus;
    maintainers = [
      maintainers.pbogdan
    ];
    platforms = platforms.linux;
  };
}
