{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  buildPythonPackage ? null,
}:

let
  mkDerivation =
    if builtins.isNull buildPythonPackage then stdenv.mkDerivation else buildPythonPackage;
in
mkDerivation rec {
  pname = "pigpio";
  version = "79";

  src = fetchFromGitHub {
    owner = "joan2937";
    repo = "pigpio";
    rev = "v${version}";
    hash = "sha256-Z+SwUlBbtWtnbjTe0IghR3gIKS43ZziN0amYtmXy7HE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Pigpio is a C library for the Raspberry which allows control of the General Purpose Input Outputs (GPIO";
    homepage = "https://github.com/joan2937/pigpio";
    license = with licenses; [ unlicense ];
    maintainers = with maintainers; [ doronbehar ];
  };
}
