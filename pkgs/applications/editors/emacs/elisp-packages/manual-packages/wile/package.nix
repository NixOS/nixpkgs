{
  lib,
  unstableGitUpdater,
  melpaBuild,
  fetchFromGitea,
}:
melpaBuild {
  pname = "wile";
  version = "0-unstable-2025-03-27";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "rahguzar";
    repo = "wile";
    rev = "d24f78ac8dac6b90acf7fcacdf8a09b849ba353c";
    hash = "sha256-dLyOvijabSMFuOJiWGbMhAZiKXpppUWi5nKS7Q9ry+I=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://codeberg.org/rahguzar/wile";
    description = "Control iwd managed wifi devices from Emacs";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ johnhamelink ];
  };

}
