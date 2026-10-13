{
  runCommand,
  python3,
  bash,
  coreutils,
  dpkg,
  gzip,
  gnused,
  gawk,
  jq,
  libxml2,
  nix,
}:
runCommand "chatgpt-updater-test"
  {
    nativeBuildInputs = [
      python3
      bash
      coreutils
      dpkg
      gzip
      gnused
      gawk
      jq
      libxml2
      nix
    ];
  }
  ''
    python3 ${./test-update.py} ${./update.sh}
    touch "$out"
  ''
