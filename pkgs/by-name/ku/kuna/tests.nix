{
  runCommandCC,
  writeText,
  kuna,
}:

let
  sampleSource = writeText "sample.c" ''
    __attribute__((noinline)) int scale(int n) { return n * 3 + 1; }
    int main(void) { return scale(19) != 58; }
  '';

  roundtripSource = writeText "roundtrip.c" ''
    int scale(int);
    int main(void) {
        return !(scale(-7) == -20 && scale(0) == 1 && scale(19) == 58);
    }
  '';
in
runCommandCC "kuna-smoke-test"
  {
    nativeBuildInputs = [ kuna ];
  }
  ''
    $CC -O1 -g0 ${sampleSource} -o sample
    kuna decompile-project sample --functions scale -o exported
    $CC -O1 exported/sample.c ${roundtripSource} -o roundtrip
    ./roundtrip
    touch $out
  ''
