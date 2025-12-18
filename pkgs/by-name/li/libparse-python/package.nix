{
  pkgs,
  callPackage,
  fetchFromGitHub,
}:

let
  pname = "libparse-python";
  version = "unstable-2025-12-15";
in

pkgs.python3Packages.buildPythonPackage {
  inherit pname version;

  pyproject = true;

  src = fetchFromGitHub {
    owner = "librelane";
    repo = "libparse-python";
    rev = "ff5b26d";
    hash = "sha256-kNCLxr5FKqXzpbKF4ogoFdthLI4S/3r9QxT5DXSVziw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'yosys/passes/techmap/libparse.cc' '${pkgs.yosys.src}/passes/techmap/libparse.cc' \
      --replace-fail '"yosys/passes/techmap"' '"${pkgs.yosys}/share/yosys/include/passes/techmap"' \
      --replace-fail '"yosys"' '"${pkgs.yosys}/share/yosys/include"'
  '';

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE \
      -I${pkgs.yosys}/share/yosys/include \
      -I${pkgs.yosys}/share/yosys/include/passes/techmap"
  '';

  nativeBuildInputs = [
    pkgs.pkg-config
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    setuptools
    pybind11
  ];

  buildInputs = [
    pkgs.yosys
  ];

  meta = with pkgs.lib; {
    description = "A Python library for parsing Yosys output for LibreLane";
    homepage = "https://github.com/librelane/libparse-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ gonsolo ];
    platforms = platforms.linux;
  };
}
