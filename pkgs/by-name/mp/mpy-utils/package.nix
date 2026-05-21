{
  stdenv,
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mpy-utils";
  version = "0.1.13";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-die8hseaidhs9X7mfFvV8C8zn0uyw08gcHNqmjl+2Z4=";
  };

  propagatedBuildInputs = with python3Packages; [
    fusepy
    pyserial
  ];

  meta = {
    description = "MicroPython development utility programs";
    homepage = "https://github.com/nickzoic/mpy-utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aciceri ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
