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
  version = "0-unstable-2024-08-20";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "videoclip";
    rev = "249122d245bc5ec2a0687346af730b1cc2273b21";
    hash = "sha256-VSMFddi8Lvmipo8Un79v+LXGNiKeaSxHQ44HddJgTkE=";
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
