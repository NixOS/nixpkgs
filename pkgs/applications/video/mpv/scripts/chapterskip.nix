{ lib
, fetchFromGitHub
, unstableGitUpdater
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
  passthru.updateScript = unstableGitUpdater {};

  meta = {
    description = "Automatically skips chapters based on title";
    longDescription = ''
    MPV script that skips chapters based on their title, categorized using regexes.
    The set of skipped categories can be configured globally, or by an auto-profile.
    '';
    homepage = "https://github.com/po5/chapterskip";
    license = lib.licenses.unfree;  # https://github.com/po5/chapterskip/issues/10
    maintainers = with lib.maintainers; [ nicoo ];
  };
}
