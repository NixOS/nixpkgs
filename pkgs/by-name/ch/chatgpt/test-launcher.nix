{
  launcher,
  runCommand,
  python3,
  util-linux,
}:
runCommand "chatgpt-launcher-test"
  {
    nativeBuildInputs = [
      python3
      util-linux
    ];
  }
  ''
    python3 ${./test-launcher.py} ${launcher}/bin/chatgpt-launcher
    touch "$out"
  ''
