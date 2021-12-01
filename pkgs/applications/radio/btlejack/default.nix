{ lib, buildPythonApplication, fetchFromGitHub, pyserial, halo }:

buildPythonApplication rec {
  pname = "btlejack";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "virtualabs";
    repo = "btlejack";
    rev = "v${version}";
    sha256 = "1r17079kx7dvsrbmw5sgvz3vj5m3pn2543gxj2xmw4s0lcihy378";
  };

  postPatch = ''
    sed -i "s|^.*'argparse',$||" setup.py
  '';

  propagatedBuildInputs = [ pyserial halo ];

  meta = with lib; {
    homepage = "https://github.com/virtualabs/btlejack";
    description = "Bluetooth Low Energy Swiss-army knife";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
