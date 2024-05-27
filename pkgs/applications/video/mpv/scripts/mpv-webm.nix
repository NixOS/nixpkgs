{
  lib,
  buildLua,
  fetchFromGitHub,
  luaPackages,
  unstableGitUpdater,
}:

buildLua {
  pname = "mpv-webm";
  version = "0-unstable-2024-05-13";

  src = fetchFromGitHub {
    owner = "ekisu";
    repo = "mpv-webm";
    rev = "8d4902b2aec92f40e4595ec9a411ab90488dcf4e";
    hash = "sha256-aPPVAZu9reDdyovSpDklYZYLaapKBclAx3lCYUMJt+w=";
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
