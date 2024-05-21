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
  version = "0-unstable-2024-03-08";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "videoclip";
    rev = "0e3f2245b03e888c14c093a50261e0f54ecdf8e8";
    hash = "sha256-Sg6LHU9OVmVx3cTs8Y0WL8wACb5BlVyeBRccoX+7BXY=";
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
