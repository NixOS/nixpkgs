{
  lib,
  stdenv,
  fetchFromGitHub,
  libnl,
  libpcap,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "mdk4";
  version = "unstable-2021-04-27";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "mdk4";
    rev = "e94422ce8e4b8dcd132d658345814df7e63bfa41";
    sha256 = "sha256-pZS7HQBKlSZJGqoZlSyBUzXC3osswcB56cBzgm+Sbwg=";
  };

  preBuild = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man

    substituteInPlace src/Makefile --replace '/usr/local/src/mdk4' '$out'
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libnl
    libpcap
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "SBINDIR=$(PREFIX)/bin"
  ];

  meta = with lib; {
    description = "Tool that injects data into wireless networks";
    homepage = "https://github.com/aircrack-ng/mdk4";
    maintainers = with maintainers; [ moni ];
    license = licenses.gpl2Plus;
    mainProgram = "mdk4";
  };
}
