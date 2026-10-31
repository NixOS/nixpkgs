{
  lib,
  buildLua,
  fetchFromGitHub,
  gitUpdater,
  stdenv,
  curl,
  wl-clipboard,
  xclip,
}:
buildLua (finalAttrs: {
  pname = "videoclip";
  version = "26.7.30.0";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "videoclip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4ptnF3/L3U0CDucYcd8/O5EN1mUtnor+iXLRXbiC7os=";
  };

  postPatch = ''
    substituteInPlace videoclip/platform.lua \
      --replace-fail "'curl'" "'${lib.getExe curl}'"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace videoclip/platform.lua \
      --replace-fail '"wl-copy' '"${lib.getExe' wl-clipboard "wl-copy"}' \
      --replace-fail '"xclip' '"${lib.getExe xclip}'
  '';

  scriptPath = "videoclip";

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Easily create videoclips with mpv";
    homepage = "https://github.com/Ajatt-Tools/videoclip";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ BatteredBunny ];
  };
})
