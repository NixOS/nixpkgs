{ lib
, fetchFromGitHub
, buildLua }:

buildLua {
  pname = "chapterskip";

  version = "unstable-2022-09-08";
  src = fetchFromGitHub {
    owner = "po5";
    repo  = "chapterskip";
    rev   = "b26825316e3329882206ae78dc903ebc4613f039";
    hash  = "sha256-OTrLQE3rYvPQamEX23D6HttNjx3vafWdTMxTiWpDy90=";
  };

  meta = {
    homepage = "https://github.com/po5/chapterskip";
    maintainers = with lib.maintainers; [ nicoo ];
  };
}
