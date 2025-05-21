{
  lib,
  buildLua,
  fetchFromGitHub,
  luaPackages,
  unstableGitUpdater,
}:

buildLua {
  pname = "mpv-webm";
  version = "0-unstable-2025-01-28";

  src = fetchFromGitHub {
    owner = "ekisu";
    repo = "mpv-webm";
    rev = "a84e6d71f002f28253cc0137a2347d99d599304e";
    hash = "sha256-sVzg0taY2EMkHLpuv7OcCk+e0aREKndfrCTuCwdHVFc=";
  };
  passthru.updateScript = unstableGitUpdater {
    # only "latest" tag pointing at HEAD
    hardcodeZeroVersion = true;
  };

  dontBuild = false;
  nativeBuildInputs = [ luaPackages.moonscript ];
  scriptPath = "build/webm.lua";

  meta = with lib; {
    description = "Simple WebM maker for mpv, with no external dependencies";
    homepage = "https://github.com/ekisu/mpv-webm";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pbsds ];
  };
}
