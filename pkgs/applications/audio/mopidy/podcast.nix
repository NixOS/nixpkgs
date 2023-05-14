{ lib, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-podcast";
  version = "3.0.0";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-Podcast";
    sha256 = "1z2b523yvdpcf8p7m7kczrvaw045lmxzhq4qj00dflxa2yw61qxr";
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
