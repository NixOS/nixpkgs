{
  lib,
  stdenv,
  fetchFromGitHub,
  qt5,
  makeDesktopItem,
  copyDesktopItems,
}:
stdenv.mkDerivation (self: {
  pname = "cloudlogoffline";
  version = "1.1.4";
  rev = "185f294ec36d7ebe40e37d70148b15f58d60bf0d";
  hash = "sha256-UEi7q3NbTgkg4tSjiksEO05YE4yjRul4qB9hFPswnK0=";

  src = fetchFromGitHub {
    inherit (self) rev hash;
    owner = "myzinsky";
    repo = "cloudLogOffline";
  };

  nativeBuildInputs =
    [
      qt5.qmake
      qt5.wrapQtAppsHook
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      copyDesktopItems
    ];

  buildInputs = [
    qt5.qtbase
    qt5.qtgraphicaleffects
    qt5.qtlocation
    qt5.qtpositioning
    qt5.qtquickcontrols2
    qt5.qtsvg
  ];

  postPatch =
    let
      targetDir = if stdenv.isDarwin then "Applications" else "bin";
    in
    ''
      substituteInPlace CloudLogOffline.pro \
        --replace 'target.path = /opt/$''${TARGET}/bin' "target.path = $out/${targetDir}"
    '';

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    install -d $out/share/pixmaps
    install -m644 images/logo_circle.svg $out/share/pixmaps/cloudlogoffline.svg
  '';

  desktopItems = lib.optionals (!stdenv.isDarwin) [
    (makeDesktopItem {
      name = "cloudlogoffline";
      desktopName = "CloudLogOffline";
      exec = "CloudLogOffline";
      icon = "cloudlogoffline";
      comment = self.meta.description;
      genericName = "Ham radio contact logbook";
      categories = [
        "Network"
        "Utility"
        "HamRadio"
      ];
    })
  ];

  meta = {
    description = "Offline frontend for Cloudlog";
    homepage = "https://github.com/myzinsky/cloudLogOffline";
    license = [ lib.licenses.lgpl3 ];
    mainProgram = "CloudLogOffline";
    maintainers = [ lib.maintainers.dblsaiko ];
    platforms = lib.platforms.unix;
  };
})
