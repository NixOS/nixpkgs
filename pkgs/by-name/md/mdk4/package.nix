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
  version = "4.2-unstable-2024-08-16";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "mdk4";
    rev = "36ca143a2e6c0b75b5ec60143b0c5eddd3d2970c";
    hash = "sha256-iwESQgvt9gLQeDKVkf9KcztQmjdCLOE0+Q0FlfbbjEU=";
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

  enableParallelBuilding = true;

  meta = {
    description = "Tool that injects data into wireless networks";
    homepage = "https://github.com/aircrack-ng/mdk4";
    maintainers = with lib.maintainers; [ moni ];
    license = lib.licenses.gpl3Plus;
    mainProgram = "mdk4";
  };
}
