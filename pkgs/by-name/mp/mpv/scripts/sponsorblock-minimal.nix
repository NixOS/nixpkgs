{
  lib,
  buildLua,
  fetchFromCodeberg,
  unstableGitUpdater,
  curl,
  coreutils,
}:

buildLua {
  pname = "mpv_sponsorblock_minimal";
  version = "0-unstable-2025-12-21";
  scriptPath = "sponsorblock_minimal.lua";

  src = fetchFromCodeberg {
    owner = "jouni";
    repo = "mpv_sponsorblock_minimal";
    rev = "8f4b186d6ea46e6fe0e5e94a53dda2f50dceb576";
    hash = "sha256-21qucigVnEaniQh7BKwFG/PDkwV51q0kzqe0ipVH6qY=";
  };
  passthru.updateScript = unstableGitUpdater { };

  preInstall = ''
    substituteInPlace sponsorblock_minimal.lua \
      --replace-fail "curl" "${lib.getExe curl}" \
      --replace-fail "sha256sum" "${lib.getExe' coreutils "sha256sum"}"
  '';

  meta = {
    description = "Minimal script to skip sponsored segments of YouTube videos";
    homepage = "https://codeberg.org/jouni/mpv_sponsorblock_minimal";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
