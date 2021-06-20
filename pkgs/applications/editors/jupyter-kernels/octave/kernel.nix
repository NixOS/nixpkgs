{ lib, octave, python3Packages }:

with python3Packages;

buildPythonPackage rec {
  pname = "octave-kernel";
  version = "0.32.0";

  src = fetchPypi {
    pname = "octave_kernel";
    inherit version;
    sha256 = "0dfbxfcf3bz4jswnpkibnjwlkgy0y4j563nrhaqxv3nfa65bksif";
  };

  propagatedBuildInputs = [ metakernel ipykernel ];

  # Tests require jupyter_kernel_test to run, but it hasn't seen a
  # release since 2017 and seems slightly abandoned.
  # Doing fetchPypi on it doesn't work, even though it exists here:
  # https://pypi.org/project/jupyter_kernel_test/.
  doCheck = false;

  meta = with lib; {
    description = "A Jupyter kernel for Octave.";
    homepage = "https://github.com/Calysto/octave_kernel";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thomasjm ];
    platforms = platforms.all;
  };
}
