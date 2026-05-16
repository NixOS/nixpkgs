{
  buildGoModule,
  runCommandCC,
}:

let
  testPackage = buildGoModule {
    name = "build-test-binaries";
    src = ./.;
    vendorHash = null;
    buildTestBinaries = true;
  };
in

runCommandCC "build-test-binaries-check"
  {
    nativeBuildInputs = [ testPackage ];
    passthru = { inherit testPackage; };
  }
  ''
    fail() {
      echo "Test failed: $1" >&2
      exit 1
    }

    command -v build-test-binaries.test ||
      fail "build-test-binaries.test not found in PATH"

    build-test-binaries.test -test.v | tee $out ||
      fail "build-test-binaries.test failed"

    grep -q "Hello from test" $out ||
      fail "Output does not contain expected string"
  ''
