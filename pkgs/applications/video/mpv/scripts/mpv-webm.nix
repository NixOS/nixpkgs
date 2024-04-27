{ lib
, buildLua
, fetchFromGitHub
, luaPackages
, unstableGitUpdater
}:

buildLua {
  pname = "mpv-webm";
  version = "unstable-2024-04-22";

  src = fetchFromGitHub {
    owner = "ekisu";
    repo = "mpv-webm";
    rev = "225e8e53842f7da6f77034309c1e54293dc629a4";
    hash = "sha256-82xWiuOChxfzX6e0+cGFxTqyuiPefyVwpvLM5ka7nPk=";
  };
  passthru.updateScript = unstableGitUpdater {};

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
