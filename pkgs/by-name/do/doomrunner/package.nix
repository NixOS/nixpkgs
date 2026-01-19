{
  lib,
  stdenv,
  kdePackages,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doomrunner";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "Youda008";
    repo = "DoomRunner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N5kj2Z3QW29kOw2khET6Z4E9nFBBjNTgKw2xbCQrWKY=";
  };

  buildInputs = [ kdePackages.qtbase ];

  nativeBuildInputs = [
    kdePackages.qmake
    kdePackages.wrapQtAppsHook
  ];

  makeFlags = [
    "INSTALL_ROOT=${placeholder "out"}"
  ];

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      mv $out/usr/bin/DoomRunner.app $out/Applications/
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      mkdir -p $out/{bin,share/applications,share/icons/hicolor/128x128/apps}
      install -Dm444 $src/Install/XDG/DoomRunner.128x128.png $out/share/icons/hicolor/128x128/apps/DoomRunner.png
      install -Dm444 $src/Install/XDG/DoomRunner.desktop $out/share/applications/DoomRunner.desktop
      install -Dm755 $out/usr/bin/DoomRunner $out/bin/DoomRunner
    ''
    + ''
      rm -rf $out/usr
    '';

  meta = {
    description = "Preset-oriented graphical launcher of various ported Doom engines";
    mainProgram = "DoomRunner";
    homepage = "https://github.com/Youda008/DoomRunner";
    changelog = "https://github.com/Youda008/DoomRunner/blob/${finalAttrs.src.rev}/changelog.txt";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ keenanweaver ];
  };
})
