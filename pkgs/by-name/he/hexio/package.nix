{
  lib,
  stdenv,
  fetchFromGitLab,
  pcsclite,
  pth,
  python3Packages,
}:
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

  nativeBuildInputs = [ python3Packages.wrapPython ];

  buildInputs = [
    pcsclite
    pth
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '-I/usr/local/include/PCSC/' '-I${lib.getDev pcsclite}/include/PCSC/' \
      --replace-fail '-L/usr/local/lib/pth' '-I${pth}/lib/'
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
