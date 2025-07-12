{ runCommand, sfxr-qt }:

runCommand "sfxr-qt-test-export-square-wave" ''
  mkdir $out
  ${sfxr-qt}/bin/sfxr-qt --export --output $out/output.wav ${./input.sfxj}
''
