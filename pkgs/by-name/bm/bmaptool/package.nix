{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "bmaptool";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "yoctoproject";
    repo = "bmaptool";
    rev = "v${version}";
    sha256 = "01xzrv5nvd2nvj91lz4x9s91y9825j9pj96z0ap6yvy3w2dgvkkl";
  };

  propagatedBuildInputs = with python3Packages; [ six ];

  # tests fail only on hydra.
  doCheck = false;

  meta = with lib; {
    description = "BMAP Tools";
    homepage = "https://github.com/yoctoproject/bmaptool";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
    mainProgram = "bmaptool";
  };
}
