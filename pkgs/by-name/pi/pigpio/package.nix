{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pigpio";
  version = "79";

  src = fetchFromGitHub {
    owner = "joan2937";
    repo = "pigpio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z+SwUlBbtWtnbjTe0IghR3gIKS43ZziN0amYtmXy7HE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  postInstall = ''
    install -Dm444 "$cmakeDir"/pigpio.py "$out/${python3.sitePackages}"/pigpio.py
  '';

  meta = with lib; {
    description = "C library for the Raspberry Pi which allows control of the General Purpose Input Outputs (GPIO)";
    license = licenses.unlicense;
    homepage = "http://abyz.me.uk/rpi/pigpio/index.html";
    platforms = platforms.linux;
    maintainers = with maintainers; [ veprbl ];
  };
})
