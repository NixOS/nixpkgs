{
  lib,
  fetchFromGitHub,
  curl,
  xclip,
  wl-clipboard,
  stdenv,
  buildLua,
  unstableGitUpdater,
}:
buildLua {
  pname = "videoclip";
  version = "0.2-unstable-2026-01-22";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "videoclip";
    rev = "4856934684e4490fc0cab0b58054eac5f07754d7";
    hash = "sha256-JQGPiVRMPZa4AkxqrNlTzC2QnJ4/kQov01nIcUuFy6I=";
  };

  patchPhase = ''
    substituteInPlace platform.lua \
    --replace \'curl\' \'${lib.getExe curl}\' \
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    --replace xclip ${lib.getExe xclip} \
    --replace wl-copy ${lib.getExe' wl-clipboard "wl-copy"}
  '';

  scriptPath = ".";
  passthru.scriptName = "videoclip";
  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
    description = "Easily create videoclips with mpv";
    homepage = "https://github.com/Ajatt-Tools/videoclip";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ BatteredBunny ];
  };
}
