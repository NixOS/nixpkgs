{ lib, buildPythonApplication, fetchFromGitHub, pyserial, halo }:

buildPythonApplication rec {
  pname = "btlejack";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "virtualabs";
    repo = "btlejack";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Q6y9murV1o2i1sluqTVB5+X3B7ywFsI0ZvlJjHrHSpo=";
  };

  postPatch = ''
    sed -i "s|^.*'argparse',$||" setup.py
  '';

  propagatedBuildInputs = [ pyserial halo ];

  meta = with lib; {
    homepage = "https://github.com/virtualabs/btlejack";
    description = "Bluetooth Low Energy Swiss-army knife";
    mainProgram = "btlejack";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
