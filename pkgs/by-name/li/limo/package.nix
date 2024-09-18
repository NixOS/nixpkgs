{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,

  jsoncpp,
  libarchive,
  libcpr,
  libloot,
  pugixml,
  unrar, # has an unfree license

  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "limo";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "limo-app";
    repo = "limo";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-eYX6CxkSnTWbltrhp1QLwnlghy7V+1lzyvcwfWoQFB8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    jsoncpp
    libarchive
    libcpr
    libloot
    pugixml
    unrar

    libsForQt5.qtbase
    libsForQt5.qtsvg
    libsForQt5.qtwayland
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LIBUNRAR_INCLUDE_DIR" "${lib.getDev unrar}/include/unrar")
    (lib.cmakeFeature "LIBUNRAR_PATH" "unrar")
  ];

  postInstall = ''
    install -Dm644 ../flatpak/io.github.limo_app.limo.png -t $out/share/icons/hicolor/512x512/apps
    install -Dm644 ../flatpak/io.github.limo_app.limo.desktop -t $out/share/applications
  '';

  meta = {
    description = "General purpose mod manager with support for the NexusMods API and LOOT";
    homepage = "https://github.com/limo-app/limo";
    license = lib.licenses.gpl3Plus;
    mainProgram = "Limo";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
