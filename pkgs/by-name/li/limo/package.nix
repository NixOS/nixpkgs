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

  libsForQt5,

  withUnrar ? false,
  unrar, # has an unfree license
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

  patches = lib.optionals (!withUnrar) [
    # remove `unrar` as fallback when libarchive fails
    ./remove-unrar.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs =
    [
      jsoncpp
      libarchive
      libcpr
      libloot
      pugixml

      libsForQt5.qtbase
      libsForQt5.qtsvg
      libsForQt5.qtwayland
    ]
    ++ lib.optionals withUnrar [
      unrar
    ];

  cmakeFlags = lib.optionals withUnrar [
    (lib.cmakeFeature "LIBUNRAR_INCLUDE_DIR" "${lib.getDev unrar}/include/unrar")
    (lib.cmakeFeature "LIBUNRAR_PATH" "unrar")
  ];

  postInstall = ''
    install -Dm644 ../flatpak/io.github.limo_app.limo.png -t $out/share/icons/hicolor/512x512/apps
    install -Dm644 ../flatpak/io.github.limo_app.limo.desktop -t $out/share/applications
    install -Dm644 ../flatpak/io.github.limo_app.limo.metainfo.xml -t $out/share/metainfo
  '';

  meta = {
    description = "General purpose mod manager with support for the NexusMods API and LOOT";
    homepage = "https://github.com/limo-app/limo";
    license = lib.licenses.gpl3Plus;
    mainProgram = "Limo";
    maintainers = with lib.maintainers; [
      tomasajt
      MattSturgeon
    ];
    platforms = lib.platforms.linux;
  };
})
