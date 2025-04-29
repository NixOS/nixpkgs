{
  lib,
  stdenv,
  kdePackages,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doomrunner";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "Youda008";
    repo = "DoomRunner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rCoMTPGjIFAcNncBGg1IMdUahzjH0WlFZBZS0UmNI/g=";
  };

  buildInputs = [ kdePackages.qtbase ];

  nativeBuildInputs = [
    kdePackages.qmake
    kdePackages.wrapQtAppsHook
  ];

  makeFlags = [
    "INSTALL_ROOT=${placeholder "out"}"
  ];

  postInstall = ''
    mkdir -p $out/{bin,share/applications,share/icons/hicolor/128x128/apps}
    install -Dm444 $src/Install/XDG/DoomRunner.128x128.png $out/share/icons/hicolor/128x128/apps/DoomRunner.png
    install -Dm444 $src/Install/XDG/DoomRunner.desktop $out/share/applications/DoomRunner.desktop
    install -Dm755 $out/usr/bin/DoomRunner $out/bin/DoomRunner
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
