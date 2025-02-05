{
  melpaBuild,
  fetchFromGitHub,
  git,
  unstableGitUpdater,
  lib,
}:

melpaBuild {
  pname = "elpaca";
  version = "0-unstable-2025-01-25";

  src = fetchFromGitHub {
    owner = "progfolio";
    repo = "elpaca";
    rev = "db2fd7258ff69fe2d100888cb8d92cf3bf94d465";
    hash = "sha256-SseY0iU3D3cloKZy6xPp8QT0H1Cu2uGiiVG6rXq/UHg=";
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
