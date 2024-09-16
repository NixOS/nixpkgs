{
  lib,
  flutter324,
  fetchFromGitHub,
}:

flutter324.buildFlutterApplication rec {
  pname = "sly";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "kra-mo";
    repo = "sly";
    rev = "refs/tags/v${version}";
    hash = "sha256-p058UnX6qi7wxxu/a1Suxxyxz8fvyS9RdExk/NDbKUo=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  meta = {
    description = "Friendly image editor that requires no internet connection or preexisting expertise";
    homepage = "https://github.com/kra-mo/sly";
    license = lib.licenses.gpl3Plus;
    mainProgram = "sly";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}
