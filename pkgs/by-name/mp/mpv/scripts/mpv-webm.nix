{
  lib,
  buildLua,
  fetchFromGitHub,
  lua55Packages,
  unstableGitUpdater,
}:

buildLua {
  pname = "mpv-webm";
  version = "0-unstable-2026-10-04";

  src = fetchFromGitHub {
    owner = "ekisu";
    repo = "mpv-webm";
    rev = "3d5dd61468a152b4f9c6a22d671573aef8d865ff";
    hash = "sha256-b1s/8jli4QMOlVe6+lbu3N3qcFMqkWoGJvljl6zmLxs=";
  };
  passthru.updateScript = unstableGitUpdater {
    # only "latest" tag pointing at HEAD
    hardcodeZeroVersion = true;
  };

  dontBuild = false;
  nativeBuildInputs = [ lua55Packages.moonscript ];
  scriptPath = "build/webm.lua";

  meta = {
    description = "Simple WebM maker for mpv, with no external dependencies";
    homepage = "https://github.com/ekisu/mpv-webm";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
