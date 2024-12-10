{
  fetchFromGitHub,
  lib,
  cmake,
  mkDerivation,
  libxcb,
  qtbase,
  qtsvg,
}:

mkDerivation rec {
  pname = "spotify-qt";
  version = "3.11";

  src = fetchFromGitHub {
    owner = "kraxarn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Dm+ELHtYZGSzJSrERtvpuuV5cVZ9ah9WQ0iTTJqGqVg=";
  };

  buildInputs = [
    libxcb
    qtbase
    qtsvg
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCMAKE_INSTALL_PREFIX=" ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "Lightweight unofficial Spotify client using Qt";
    mainProgram = "spotify-qt";
    homepage = "https://github.com/kraxarn/spotify-qt";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
