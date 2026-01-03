{
  lib,
  flutter329,
  fetchFromGitHub,
}:

flutter329.buildFlutterApplication rec {
  pname = "convertall";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "doug-101";
    repo = "ConvertAll";
    tag = "v${version}";
    hash = "sha256-esc2xhL0Jx5SaqM0GnnVzdtnSN9bX8zln66We/2RqoA=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  meta = {
    homepage = "https://convertall.bellz.org";
    description = "Graphical unit converter";
    mainProgram = "convertall";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
