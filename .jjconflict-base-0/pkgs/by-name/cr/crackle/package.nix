{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  coreutils,
}:

stdenv.mkDerivation {
  pname = "crackle";
  version = "unstable-2020-12-13";

  src = fetchFromGitHub {
    owner = "mikeryan";
    repo = "crackle";
    rev = "d83b4b6f4145ca53c46c36bbd7ccad751af76b75";
    sha256 = "sha256-Dy4s/hr9ySrogltyk2GVsuAvwNF5+b6CDjaD+2FaPHA=";
  };

  buildInputs = [ libpcap ];

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
    "INSTALL=${coreutils}/bin/install"
  ];

  meta = with lib; {
    description = "Crack and decrypt BLE encryption";
    homepage = "https://github.com/mikeryan/crackle";
    maintainers = with maintainers; [ moni ];
    license = licenses.bsd2;
    mainProgram = "crackle";
  };
}
