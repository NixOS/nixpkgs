{ cue
, runCommand
}:

runCommand "cue-test-001-all-good-${cue.version}" {
  nativeBuildInputs = [ cue ];
  meta.timeout = 10;
} ''
    cue eval - <<<'a: "all good"' > $out
  ''
