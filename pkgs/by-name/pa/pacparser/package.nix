{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "pacparser";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "manugarg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-X842+xPjM404aQJTc2JwqU4vq8kgyKhpnqVu70pNLks=";
  };

  makeFlags = [
    "NO_INTERNET=1"
    "PREFIX=${placeholder "out"}"
  ];

  preConfigure = ''
    patchShebangs tests/runtests.sh
    cd src
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Library to parse proxy auto-config (PAC) files";
    homepage = "https://pacparser.manugarg.com/";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
    mainProgram = "pactester";
  };
}
