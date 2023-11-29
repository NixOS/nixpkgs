{ lib
, buildLua
, fetchFromGitHub
, luaPackages
}:

buildLua {
  pname = "mpv-webm";
  version = "unstable-2023-02-23";

  src = fetchFromGitHub {
    owner = "ekisu";
    repo = "mpv-webm";
    rev = "a18375932e39e9b2a40d9c7ab52ea367b41e2558";
    hash = "sha256-aetkQ1gU/6Yys5FJS/N06ED9tCSvL6BAgUGdNmNmpbU=";
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
