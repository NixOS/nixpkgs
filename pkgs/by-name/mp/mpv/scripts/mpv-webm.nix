{
  lib,
  buildLua,
  fetchFromGitHub,
  luaPackages,
  unstableGitUpdater,
}:

buildLua {
  pname = "mpv-webm";
  version = "0-unstable-2026-09-12";

  src = fetchFromGitHub {
    owner = "ekisu";
    repo = "mpv-webm";
    rev = "7d0a5c45ed6b878ddb1a5b609bb92388b27849f8";
    hash = "sha256-m9IoyRiYzbePGxf4WfcXM8uHljAnnBOS3VK4P4GFR98=";
  };
  passthru.updateScript = unstableGitUpdater {
    # only "latest" tag pointing at HEAD
    hardcodeZeroVersion = true;
  };

  dontBuild = false;
  nativeBuildInputs = [ luaPackages.moonscript ];
  scriptPath = "build/webm.lua";

  meta = {
    description = "Simple WebM maker for mpv, with no external dependencies";
    homepage = "https://github.com/ekisu/mpv-webm";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
