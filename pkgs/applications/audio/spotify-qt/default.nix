{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  libxcb,
  qtbase,
  qtsvg,
  wrapQtAppsHook,
  procps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spotify-qt";
  version = "3.12";

  src = fetchFromGitHub {
    owner = "kraxarn";
    repo = "spotify-qt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j9g2fq12gsue0pc/fLoCAtDlwwlbCVJ65kxPiTJTqvk=";
  };

  postPatch = ''
    substituteInPlace src/spotifyclient/helper.cpp \
      --replace-fail /usr/bin/ps ${lib.getExe' procps "ps"}
  '';

  buildInputs = [
    libxcb
    qtbase
    qtsvg
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  cmakeFlags = [ (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "") ];

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
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
})
