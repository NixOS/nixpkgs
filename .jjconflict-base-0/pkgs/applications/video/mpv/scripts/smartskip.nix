{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:

buildLua {
  pname = "smartskip";
  version = "0-unstable-2023-11-25";

  scriptPath = "scripts/SmartSkip.lua";
  src = fetchFromGitHub {
    owner = "Eisa01";
    repo = "mpv-scripts";
    rev = "48d68283cea47ff8e904decc9003b3abc3e2123e";
    hash = "sha256-95CAKjBRELX2f7oWSHFWJnI0mikAoxhfUphe9k51Qf4=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Automatically or manually skip opening, intro, outro, and preview";
    homepage = "https://github.com/Eisa01/mpv-scripts";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.iynaix ];
  };
}
