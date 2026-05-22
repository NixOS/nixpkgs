{
  bun,
  runCommand,
  writeText,
  testers,
}:

testers.testEqualContents {
  assertion = "bun compiles a hello world binary that prints the correct version";
  expected = writeText "expected" "Hello from Bun v${bun.version}\n";
  actual =
    runCommand "actual"
      {
        nativeBuildInputs = [ bun ];
        meta.timeout = 120;
      }
      ''
        cat >hello.ts <<'EOF'
        console.log("Hello from Bun v" + Bun.version);
        EOF

        bun build --compile hello.ts --outfile hello

        ./hello > $out
      '';
}
