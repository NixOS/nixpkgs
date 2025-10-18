{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  libxcb,
  procps,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spotify-qt";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "kraxarn";
    repo = "spotify-qt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R6ucuQdntc1OxDCV8jDAlyjAo/393HN7fjRJH70OdNs=";
  };

  postPatch = ''
    substituteInPlace src/spotifyclient/helper.cpp \
      --replace-fail /usr/bin/ps ${lib.getExe' procps "ps"}
  '';

  buildInputs = [
    libxcb
    kdePackages.qtbase
    kdePackages.qtsvg
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
  ];

  cmakeFlags = [ (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "") ];

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/spotify-qt.app $out/Applications
    ln $out/Applications/spotify-qt.app/Contents/MacOS/spotify-qt $out/bin/spotify-qt
  '';

  meta = {
    description = "Lightweight unofficial Spotify client using Qt";
    mainProgram = "spotify-qt";
    homepage = "https://github.com/kraxarn/spotify-qt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ iivusly ];
    platforms = lib.platforms.unix;
  };
})
