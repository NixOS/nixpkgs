{
  lib,
  flutter329,
  fetchFromGitHub,
}:

flutter329.buildFlutterApplication rec {
  pname = "convertall";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "doug-101";
    repo = "ConvertAll";
    tag = "v${version}";
    hash = "sha256-wsSe7dVjEgLDOIavcMzdxW9LKZcZPaQMcw4RhsPS0jU=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  meta = {
    homepage = "https://convertall.bellz.org";
    description = "Graphical unit converter";
    mainProgram = "convertall";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ orivej ];
    platforms = lib.platforms.linux;
  };
}
