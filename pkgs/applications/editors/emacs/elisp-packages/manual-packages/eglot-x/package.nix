{
  lib,
  melpaBuild,
  fetchFromGitHub,
  unstableGitUpdater,
}:
melpaBuild {
  pname = "eglot-x";
  version = "0-unstable-2026-02-16";
  src = fetchFromGitHub {
    owner = "nemethf";
    repo = "eglot-x";
    rev = "46bca93291727454dd92567e761a1e2ab5622590";
    hash = "sha256-c8NzzK7SOYYDB803Osp3TOymrmwC07+dcvbI4waAfco=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/nemethf/eglot-x";
    description = "Protocol extensions for Eglot";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ johnhamelink ];
  };
}
