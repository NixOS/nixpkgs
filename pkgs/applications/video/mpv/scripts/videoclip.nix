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
  version = "0-unstable-2024-05-26";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "videoclip";
    rev = "4fd40d66c95905ed828ca77b7120732014b93ac5";
    hash = "sha256-Q40a7BBY4c7I5g9HkeV6Twv/PDPBDKTlnxkILw99pxU=";
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
