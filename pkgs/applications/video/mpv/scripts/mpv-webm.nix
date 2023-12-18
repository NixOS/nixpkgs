{ lib
, buildLua
, fetchFromGitHub
, luaPackages
, nix-update-script
}:

buildLua {
  pname = "mpv-webm";
  version = "unstable-2023-11-18";

  src = fetchFromGitHub {
    owner = "ekisu";
    repo = "mpv-webm";
    rev = "6b5863f68275b3dc91c2507284c039ec8a4cbd97";
    hash = "sha256-rJamBm6FyxWcJO7VXXOUTO9piWCkPfEVdqGKGeJ/h0c=";
  };

  dontBuild = false;
  nativeBuildInputs = [ luaPackages.moonscript ];
  scriptPath = "build/webm.lua";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    description = "Simple WebM maker for mpv, with no external dependencies";
    homepage = "https://github.com/ekisu/mpv-webm";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pbsds ];
  };
}
