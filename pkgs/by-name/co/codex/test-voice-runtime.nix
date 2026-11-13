{
  codex,
  python3,
  runCommand,
}:
runCommand "${codex.name}-voice-runtime-test"
  {
    nativeBuildInputs = [ python3 ];
  }
  ''
    python3 ${./test-voice-runtime.py} \
      ${codex} \
      ${codex.buildCommit}
    touch $out
  ''
