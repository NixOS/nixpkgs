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
  version = "0.2-unstable-2026-07-07";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "videoclip";
    rev = "979bae398da7ccd70cb2fb305c371b7af9259b10";
    hash = "sha256-k3fxSeAjRZg4J5x5IQhKGYtUqfBE4heR1KNurGTElGs=";
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
