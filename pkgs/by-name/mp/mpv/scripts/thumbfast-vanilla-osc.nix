{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:

buildLua {
  pname = "thumbfast-vanilla-osc";
  version = "0-unstable-2025-02-04";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "thumbfast";
    rev = "9d78edc167553ccea6290832982d0bc15838b4ac";
    hash = "sha256-AG3w5B8lBcSXV4cbvX3nQ9hri/895xDbTsdaqF+RL64=";
  };
  passthru.updateScript = unstableGitUpdater { branch = "vanilla-osc"; };

  scriptPath = "player/lua/osc.lua";

  meta = {
    description = "Modified version of the vanilla UI with thumbfast support";
    homepage = "https://github.com/po5/thumbfast";
    # License not stated explicitly, but is a derivative of https://github.com/mpv-player/mpv/blob/master/player/lua/osc.lua
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ coca ];
  };
}
