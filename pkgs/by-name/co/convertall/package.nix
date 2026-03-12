{
  lib,
  flutter341,
  fetchFromGitHub,
}:

flutter341.buildFlutterApplication rec {
  pname = "convertall";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "doug-101";
    repo = "ConvertAll";
    tag = "v${version}";
    hash = "sha256-f9HfLfxY2G/3rZoWJ1xLeGmkdFiIyUFkr65Jf8QMqjY=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  meta = {
    homepage = "https://convertall.bellz.org";
    description = "Graphical unit converter";
    mainProgram = "convertall";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      Luflosi
    ];
    platforms = lib.platforms.linux;
  };
}
