{
  lib,
  flutter341,
  fetchFromGitHub,
  copyDesktopItems,
  libayatana-appindicator,
  makeDesktopItem,
  runCommand,
  yq-go,
  imagemagick,
  _experimental-update-script-combinators,
  nix-update-script,
}:

flutter341.buildFlutterApplication (finalAttrs: {
  pname = "alisthelper";
  version = "0.2.0-unstable-2026-03-13";

  src = fetchFromGitHub {
    owner = "Xmarmalade";
    repo = "alisthelper";
    rev = "6d7e1acb86a5c67bcf86d99bc6034f130b1d04c2";
    hash = "sha256-EIE90R4lCnCLAi6D0YFdntB/tIhqKnoVhbqzk/4bj/k=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    imagemagick
    copyDesktopItems
  ];

  buildInputs = [ libayatana-appindicator ];

  preBuild = ''
    packageRun slang
    packageRun build_runner build --delete-conflicting-outputs
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "alisthelper";
      exec = "alisthelper";
      icon = "alisthelper";
      desktopName = "Alist Helper";
    })
  ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/1024x1024/apps
    magick assets/alisthelper.png -resize 1024x1024 $out/share/icons/hicolor/1024x1024/apps/alisthelper.png
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit (finalAttrs) src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { extraArgs = [ "--version=branch" ]; })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "alisthelper.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
    ];
  };

  meta = {
    description = "Designed to simplify the use of the desktop version of alist/openlist";
    homepage = "https://github.com/Xmarmalade/alisthelper";
    mainProgram = "alisthelper";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
