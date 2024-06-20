{
  fetchFromGitHub,
  buildLua,
  lib,
  unstableGitUpdater,
}:

buildLua {
  pname = "memo";
  version = "0-unstable-2023-10-31";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "memo";
    rev = "6f2b036ef860e130ea584657389e0a7ceb4d954f";
    hash = "sha256-m8ikXuw7PM4Btg8w7ufLneKA4fnYjMyfVJYueZILMw8=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Recent files menu for mpv";
    homepage = "https://github.com/po5/memo";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ purrpurrn ];
  };
}
