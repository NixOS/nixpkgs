{
  lib,
  buildLua,
  fetchFromGitHub,
  luaPackages,
  unstableGitUpdater,
}:

buildLua {
  pname = "mpv-webm";
  version = "0-unstable-2026-03-01";

  src = fetchFromGitHub {
    owner = "ekisu";
    repo = "mpv-webm";
    rev = "8d703b49dffa954d19a61e3c61d19514607b2e0d";
    hash = "sha256-Kl5LkdMcUtQAkx/hWvAjebvaptcURfDzOe5oMyBqY4I=";
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
