{
  stdenvNoCC,
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
  version = "3.12";

  src = fetchFromGitHub {
    owner = "kraxarn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-j9g2fq12gsue0pc/fLoCAtDlwwlbCVJ65kxPiTJTqvk=";
  };

  buildInputs = [
    libxcb
    qtbase
    qtsvg
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCMAKE_INSTALL_PREFIX=" ];

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/spotify-qt.app $out/Applications
    ln $out/Applications/spotify-qt.app/Contents/MacOS/spotify-qt $out/bin/spotify-qt
  '';

  meta = with lib; {
    description = "Lightweight unofficial Spotify client using Qt";
    mainProgram = "spotify-qt";
    homepage = "https://github.com/kraxarn/spotify-qt";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ iivusly ];
    platforms = platforms.unix;
  };
}
