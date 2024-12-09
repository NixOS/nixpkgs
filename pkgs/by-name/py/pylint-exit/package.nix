{ lib, fetchFromGitHub, python3Packages }:

with python3Packages; buildPythonApplication rec {
  pname = "pylint-exit";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jongracecox";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hwfny48g394visa3xd15425fsw596r3lhkfhswpjrdk2mnk3cny";
  };

  # Converting the shebang manually as it is not picked up by patchShebangs
  postPatch = ''
    substituteInPlace pylint_exit.py \
      --replace "#!/usr/local/bin/python" "#!${python.interpreter}"
  '';

  # See https://github.com/jongracecox/pylint-exit/pull/7
  buildInputs = [ m2r ];

  # setup.py reads its version from the TRAVIS_TAG environment variable
  TRAVIS_TAG = version;

  checkPhase = ''
    ${python.interpreter} -m doctest pylint_exit.py
  '';

  meta = with lib; {
    description = "Utility to handle pylint exit codes in an OS-friendly way";
    license = licenses.mit;
    homepage = "https://github.com/jongracecox/pylint-exit";
    maintainers = [ maintainers.fabiangd ];
  };
}
