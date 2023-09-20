{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "emu2";
  version = "0.pre+unstable=2021-09-22";

  src = fetchFromGitHub {
    owner = "dmsc";
    repo = "emu2";
    rev = "8d01b53f154d6bfc9561a44b9c281b46e00a4e87";
    hash = "sha256-Jafl0Pw2k5RCF9GgpdAWcQ+HBTsiX7dOKSMCWPHQ+2E=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/dmsc/emu2/";
    description = "A simple text-mode x86 + DOS emulator";
    platforms = platforms.linux;
    maintainers = with maintainers; [ AndersonTorres ];
    license = licenses.gpl2Plus;
  };
}
