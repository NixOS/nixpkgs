{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "btlejack";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "virtualabs";
    repo = "btlejack";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-Q6y9murV1o2i1sluqTVB5+X3B7ywFsI0ZvlJjHrHSpo=";
  };

  postPatch = ''
    sed -i "s|^.*'argparse',$||" setup.py
  '';

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.pyserial
    python3Packages.halo
  ];

  meta = {
    homepage = "https://github.com/virtualabs/btlejack";
    description = "Bluetooth Low Energy Swiss-army knife";
    mainProgram = "btlejack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oxzi ];
  };
})
