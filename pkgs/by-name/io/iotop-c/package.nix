{
  stdenv,
  fetchFromGitHub,
  lib,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "iotop-c";
  version = "1.31";

  src = fetchFromGitHub {
    owner = "Tomas-M";
    repo = "iotop";
    rev = "v${version}";
    sha256 = "sha256-zJI6zPkkd9GIpnAfRMVLR9Xqog0sgxTnO/NTN3hsjKU=";
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

  meta = {
    description = "Iotop identifies processes that use high amount of input/output requests on your machine";
    homepage = "https://github.com/Tomas-M/iotop";
    maintainers = [ lib.maintainers.arezvov ];
    mainProgram = "iotop-c";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
