{
  melpaBuild,
  fetchFromGitHub,
  git,
  unstableGitUpdater,
  lib,
}:

melpaBuild {
  pname = "elpaca";
  version = "0-unstable-2025-02-16";

  src = fetchFromGitHub {
    owner = "progfolio";
    repo = "elpaca";
    rev = "07b3a653e2411f4d4b5902af1c9b3f159e07bec5";
    hash = "sha256-+YJX2BJxH3D5u7YC/yJskZu0F4Nlat3ZROe+RCZGq9w=";
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
