{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:

buildLua {
  pname = "mpv-smartskip";
  version = "0-unstable-2023-11-25";

  scriptPath = "scripts/SmartSkip.lua";
  src = fetchFromGitHub {
    owner = "Eisa01";
    repo = "mpv-scripts";
    rev = "48d68283cea47ff8e904decc9003b3abc3e2123e";
    sha256 = "sha256-95CAKjBRELX2f7oWSHFWJnI0mikAoxhfUphe9k51Qf4=";
  };
  passthru.scriptName = "SmartSkip.lua";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Automatically or manually skip opening, intro, outro, and preview, like never before. Jump to next file, previous file, and save your chapter changes!";
    homepage = "https://github.com/Eisa01/mpv-scripts";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.iynaix ];
  };
}
