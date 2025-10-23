{
  stdenv,
  fetchFromGitHub,
  lib,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "iotop-c";
  version = "1.30";

  src = fetchFromGitHub {
    owner = "Tomas-M";
    repo = "iotop";
    rev = "v${version}";
    sha256 = "sha256-L0zChYDtlEi9tdHdNNWO0KugTorFIbYK0zDPNcLUMuo=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses ];

  makeFlags = [
    "TARGET=iotop-c"
    "PREFIX=${placeholder "out"}"
    "BINDIR=${placeholder "out"}/bin"
  ];

  postInstall = ''
    mv $out/share/man/man8/{iotop,iotop-c}.8
  '';

  meta = with lib; {
    description = "Iotop identifies processes that use high amount of input/output requests on your machine";
    homepage = "https://github.com/Tomas-M/iotop";
    maintainers = [ maintainers.arezvov ];
    mainProgram = "iotop-c";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
