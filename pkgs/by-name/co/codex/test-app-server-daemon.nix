{
  codex,
  lib,
  runCommand,
}:
let
  codexBin = lib.getExe codex;
in
runCommand "${codex.name}-app-server-daemon-test"
  {
    meta.platforms = lib.platforms.linux;
  }
  ''
    export CODEX_HOME="$TMPDIR/codex-home"
    mkdir -p "$CODEX_HOME/app-server-daemon"
    printf '%s\n' '{ "shutdownGraceSeconds": 0 }' > "$CODEX_HOME/app-server-daemon/settings.json"

    ${codexBin} app-server daemon start
    ${codexBin} app-server daemon stop

    touch $out
  ''
