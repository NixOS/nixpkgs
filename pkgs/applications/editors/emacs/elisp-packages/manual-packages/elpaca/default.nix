{
  melpaBuild,
  fetchFromGitHub,
  git,
  unstableGitUpdater,
  lib,
}:

melpaBuild {
  pname = "elpaca";
  version = "0-unstable-2025-11-06";

  src = fetchFromGitHub {
    owner = "progfolio";
    repo = "elpaca";
    rev = "b5ef5f19ac1224853234c9acdac0ec9ea1c440a1";
    hash = "sha256-EZ9emYTweRZzMKxZu9nbAaGgE2tInaL7KCKvJ5TaD0g=";
  };

  nativeBuildInputs = [ git ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/progfolio/elpaca";
    description = "Elisp package manager";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ abhisheksingh0x558 ];
  };
}
