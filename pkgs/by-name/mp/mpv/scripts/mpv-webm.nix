{
  lib,
  buildLua,
  fetchFromGitHub,
  luaPackages,
  unstableGitUpdater,
}:

buildLua {
  pname = "mpv-webm";
  version = "0-unstable-2026-09-14";

  src = fetchFromGitHub {
    owner = "ekisu";
    repo = "mpv-webm";
    rev = "395a5835909df26b556b4e929498d93f95638270";
    hash = "sha256-hWX7RySnvzVBz3d/MnJuex4ZJ7Z/RnyNIAr2YaecmqY=";
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
