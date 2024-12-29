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
  version = "0-unstable-2024-07-18";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "videoclip";
    rev = "fe731767ca481678b4a166fbce6b30d3eaf8a6ce";
    hash = "sha256-Z63kccjl8jd6C0dvpK7SQnPpmDCgH3/Kzm1oRXJ0NqI=";
  };

  patchPhase =
    ''
      substituteInPlace platform.lua \
      --replace \'curl\' \'${lib.getExe curl}\' \
    ''
    + lib.optionalString stdenv.isLinux ''
      --replace xclip ${lib.getExe xclip} \
      --replace wl-copy ${lib.getExe' wl-clipboard "wl-copy"}
    '';

  scriptPath = ".";
  passthru.scriptName = "videoclip";
  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Easily create videoclips with mpv";
    homepage = "https://github.com/Ajatt-Tools/videoclip";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ BatteredBunny ];
  };
}
