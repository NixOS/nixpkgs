{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "hyp-server";
  version = "1.2.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lafjdcn9nnq6xc3hhyizfwh6l69lc7rixn6dx65aq71c913jc15";
  };

  build-system = with python3Packages; [
    setuptools
  ];

<<<<<<< HEAD
  meta = {
    description = "Hyperminimal https server";
    mainProgram = "hyp";
    homepage = "https://github.com/rnhmjoj/hyp";
    license = with lib.licenses; [
      gpl3Plus
      mit
    ];
    maintainers = with lib.maintainers; [ rnhmjoj ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Hyperminimal https server";
    mainProgram = "hyp";
    homepage = "https://github.com/rnhmjoj/hyp";
    license = with licenses; [
      gpl3Plus
      mit
    ];
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
