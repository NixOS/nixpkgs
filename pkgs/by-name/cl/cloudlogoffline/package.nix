{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  makeDesktopItem,
  copyDesktopItems,
}:
stdenv.mkDerivation (self: {
  pname = "cloudlogoffline";
  version = "1.1.5";
  rev = self.version;
  hash = "sha256-CF56yk7hsM4M43le+CLy93oLyZ9kaqaRTFWtjJuF6Vo=";

  src = fetchFromGitHub {
    inherit (self) rev hash;
    owner = "myzinsky";
    repo = "cloudLogOffline";
  };

  nativeBuildInputs =
    [
      qt6.qmake
      qt6.wrapQtAppsHook
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      copyDesktopItems
    ];

  buildInputs = [
    qt6.qtbase
    qt6.qtlocation
    qt6.qtpositioning
    qt6.qtsvg
  ];

  postPatch =
    let
      targetDir = if stdenv.hostPlatform.isDarwin then "Applications" else "bin";
    in
    ''
      substituteInPlace CloudLogOffline.pro \
        --replace 'target.path = /opt/$''${TARGET}/bin' "target.path = $out/${targetDir}"
    '';

  postInstall =
    lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      install -d $out/share/pixmaps
      install -m644 images/logo_circle.svg $out/share/pixmaps/cloudlogoffline.svg
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # FIXME: For some reason, the Info.plist isn't copied correctly to
      # the application bundle when building normally, instead creating an
      # empty file. This doesn't happen when building in a dev shell with
      # genericBuild.
      # So, just copy the file manually.
      plistPath="$out/Applications/CloudLogOffline.app/Contents/Info.plist"
      [[ -s "$plistPath" ]] && { echo "expected Info.plist to be empty; workaround no longer needed?"; exit 1; }
      install -m644 macos/Info.plist $out/Applications/CloudLogOffline.app/Contents/Info.plist
    '';

  desktopItems = lib.optionals (!stdenv.hostPlatform.isDarwin) [
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
