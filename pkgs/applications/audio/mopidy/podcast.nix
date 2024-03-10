{ lib, python3Packages, fetchPypi, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-podcast";
  version = "3.0.1";

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-Podcast";
    sha256 = "sha256-grNPVEVM2PlpYhBXe6sabFjWVB9+q+apIRjcHUxH52A=";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.cachetools
    python3Packages.uritools
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/tkem/mopidy-podcast";
    description = "Mopidy extension for browsing and playing podcasts";
    license = licenses.asl20;
    maintainers = [
      maintainers.daneads
    ];
  };
}
