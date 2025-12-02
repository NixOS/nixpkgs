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
  version = "0-unstable-2025-11-20";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "videoclip";
    rev = "1c6531b649d3ee526cc7aa360e726aeedf43beb9";
    hash = "sha256-lBXlvFrDC1Drz5JIiI6488UoFsXz18LAxqRpQmy1G0k=";
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
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    description = "Easily create videoclips with mpv";
    homepage = "https://github.com/Ajatt-Tools/videoclip";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ BatteredBunny ];
  };
}
