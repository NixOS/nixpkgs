{
  fetchFromGitHub,
  buildLua,
  lib,
  unstableGitUpdater,
}:

buildLua {
  pname = "memo";
  version = "0-unstable-2024-09-03";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "memo";
    rev = "e0624611438b2e19ef4b7e24f53461c9d0304b07";
    hash = "sha256-6+fI3TdBDfKcozxLcsykavgi17ywqRRhyiMK7PgAzGs=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Recent files menu for mpv";
    homepage = "https://github.com/po5/memo";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ purrpurrn ];
  };
}
