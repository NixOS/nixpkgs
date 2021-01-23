{ lib
, mopidy
, python3Packages
, fetchpatch
}:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Local";
  version = "3.2.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "14f78sb3wkg83dg3xcqlq77dh059zzcwry5l9ilyhnmvmyrkhqx0";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.uritools
  ];

  checkInputs = [
    python3Packages.pytestCheckHook
  ];

  patches = [
    # Fix tests for Mopidy≥3.1.0. Remove with the next release.
    (fetchpatch {
      url = "https://github.com/mopidy/mopidy-local/commit/f1d7598d3a9587f0823acb97ecb615f4f4817fd2.patch";
      sha256 = "193kd5zwsr0qpp2y8icdy13vqpglmjdm7x1rw5hliwyq18a34vjp";
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-local";
    description = "Mopidy extension for playing music from your local music archive";
    license = licenses.asl20;
    maintainers = with maintainers; [ ruuda ];
  };
}
