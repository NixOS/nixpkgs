{
  lib,
  fetchFromGitHub,
  buildLua,
  alass,
}:

buildLua {
  pname = "autosubsync-mpv";
  version = "0-unstable-2022-12-26";

  src = fetchFromGitHub {
    owner = "joaquintorres";
    repo = "autosubsync-mpv";
    rev = "22cb928ecd94cc8cadaf8c354438123c43e0c70d";
    sha256 = "sha256-XQPFC7l9MTZAW5FfULRQJfu/7FuGj9bbjQUZhNv0rlc=";
  };

  # While nixpkgs only packages alass, we might as well make that the default
  patchPhase = ''
    runHook prePatch
    substituteInPlace autosubsync.lua                                            \
      --replace-warn 'alass_path = ""' 'alass_path = "${alass}/bin/alass-cli"'   \
      --replace-warn 'audio_subsync_tool = "ask"' 'audio_subsync_tool = "alass"' \
      --replace-warn 'altsub_subsync_tool = "ask"' 'altsub_subsync_tool = "alass"'
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
