{
  lib,
  buildLua,
  fetchFromGitea,
  unstableGitUpdater,
  curl,
  coreutils,
}:

buildLua {
  pname = "mpv_sponsorblock_minimal";
  version = "0-unstable-2025-09-09";
  scriptPath = "sponsorblock_minimal.lua";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "jouni";
    repo = "mpv_sponsorblock_minimal";
    rev = "fc0db1fbffc873ca02ced7602274393fde8857e5";
    hash = "sha256-DOgJ1gZybfIFJQ5qt4B93ugHz1o+RJ7E8Cnb7itYfTs=";
  };
  passthru.updateScript = unstableGitUpdater { };

  preInstall = ''
    substituteInPlace sponsorblock_minimal.lua \
      --replace-fail "curl" "${lib.getExe curl}" \
      --replace-fail "sha256sum" "${lib.getExe' coreutils "sha256sum"}"
  '';

  meta = with lib; {
    description = "Minimal script to skip sponsored segments of YouTube videos";
    homepage = "https://codeberg.org/jouni/mpv_sponsorblock_minimal";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ arthsmn ];
  };
}
