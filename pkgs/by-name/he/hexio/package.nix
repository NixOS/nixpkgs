{
  lib,
  stdenv,
  fetchFromGitLab,
  pcsclite,
  pth,
  python3,
}:
let
  wrappedPython = python3.pkgs.wrapPython.override {
    python = python3;
  };
in
stdenv.mkDerivation rec {
  pname = "hexio";
  version = "1.1";

  src = fetchFromGitLab {
    owner = "vanrein";
    repo = "hexio";
    tag = "v${version}";
    hash = "sha256-jp7VHT08Rhw5nUtNpqkRHDHT0R51PCBy0cKb1sI6zkg=";
  };

  strictDeps = true;

  nativeBuildInputs = [ wrappedPython ];

  buildInputs = [
    pcsclite
    pth
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-I/usr/local/include/PCSC/' '-I${lib.getDev pcsclite}/include/PCSC/' \
      --replace '-L/usr/local/lib/pth' '-I${pth}/lib/'
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/sbin $out/man
    make DESTDIR=$out PREFIX=/ all
    make DESTDIR=$out PREFIX=/ install
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Low-level I/O helpers for hexadecimal, tty/serial devices and so on";
    homepage = "https://github.com/vanrein/hexio";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
