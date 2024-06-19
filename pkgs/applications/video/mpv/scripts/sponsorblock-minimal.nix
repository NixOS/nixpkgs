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
  version = "0-unstable-2023-08-20";
  scriptPath = "sponsorblock_minimal.lua";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "jouni";
    repo = "mpv_sponsorblock_minimal";
    rev = "ca2844b8cf7674bfccd282d389a50427742251d3";
    hash = "sha256-28HWZ6nOhKiE+5Ya1N3Vscd8aeH9OKS0t72e/xPfFQQ=";
  };
  passthru.updateScript = unstableGitUpdater { };

  preInstall = ''
    substituteInPlace sponsorblock_minimal.lua \
      --replace-fail "curl" "${lib.getExe curl}" \
      --replace-fail "sha256sum" "${lib.getExe' coreutils "sha256sum"}"
  '';

  meta = with lib; {
    description = "A minimal script to skip sponsored segments of YouTube videos";
    homepage = "https://codeberg.org/jouni/mpv_sponsorblock_minimal";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ arthsmn ];
  };
}
