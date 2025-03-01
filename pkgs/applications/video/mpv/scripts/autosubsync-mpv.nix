{
  lib,
  fetchFromGitHub,
  buildLua,
  ffsubsync,
}:

buildLua {
  pname = "autosubsync-mpv";
  version = "0-unstable-2024-10-29";

  src = fetchFromGitHub {
    owner = "joaquintorres";
    repo = "autosubsync-mpv";
    rev = "125ac13d1b84b3a64bb2e912225a8356c1c01364";
    sha256 = "sha256-Xwu8WTB3p3YDTydfyidF/zpN6CyTQyZgQvGX/HAa9hw=";
  };

  # While nixpkgs only packages alass, we might as well make that the default
  patchPhase = ''
    runHook prePatch
    substituteInPlace autosubsync.lua                                            \
      --replace-warn 'ffsubsync_path = ""' 'ffsubsync_path = "${lib.getExe ffsubsync}"'   \
      --replace-warn 'audio_subsync_tool = "ask"' 'audio_subsync_tool = "ffsubsync"' \
      --replace-warn 'altsub_subsync_tool = "ask"' 'altsub_subsync_tool = "ffsubsync"'
    runHook postPatch
  '';

  scriptPath = "./";
  passthru.scriptName = "autosubsync-mpv";

  meta = with lib; {
    description = "Automatically sync subtitles in mpv using the `n` button";
    homepage = "https://github.com/joaquintorres/autosubsync-mpv";
    maintainers = with maintainers; [ kovirobi ];
    license = licenses.mit;
  };
}
