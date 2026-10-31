{
  lib,
  buildLua,
  fetchFromGitHub,
  gitUpdater,
}:
buildLua (finalAttrs: {
  pname = "mpv-cheatsheet-ng";
  version = "0.1.0";
  scriptPath = "cheatsheet.lua";

  src = fetchFromGitHub {
    owner = "ambroisie";
    repo = "mpv-cheatsheet-ng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5CVEf5SPNiYaKKp0tn4zhwUvP5R75HU5/B+l8KCXJNg=";
  };

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "mpv script for looking up keyboard shortcuts";
    homepage = "https://github.com/ambroisie/mpv-cheatsheet-ng";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ambroisie ];
  };
})
