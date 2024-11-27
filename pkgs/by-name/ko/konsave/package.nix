{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "konsave";
  version = "2.2.0";

  src = fetchPypi {
    inherit version;
    pname = "Konsave";
    hash = "sha256-tWarqT2jFgCuSsa2NwMHRaR3/wj0khiRHidvRNMwM8M=";
  };

  nativeBuildInputs = with python3Packages; [ setuptools-scm ];
  propagatedBuildInputs = with python3Packages; [ pyyaml setuptools ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Save Linux Customization";
    mainProgram = "konsave";
    maintainers = with maintainers; [ MoritzBoehme ];
    homepage = "https://github.com/Prayag2/konsave";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
