{
  buildPackages,
  libffi-wasm,
  stdenv,
}:

buildPackages.runCommand "libffi-wasm-upstream-tests"
  {
    strictDeps = true;
    __structuredAttrs = true;

    nativeBuildInputs = [
      stdenv.cc
      buildPackages.wasmtime
    ];

    buildInputs = [
      libffi-wasm
    ];

    env = {
      NIX_CFLAGS_COMPILE = "-mcpu=mvp";
      NIX_LDFLAGS = "-lffi";
    };
  }
  ''
    cp -r ${libffi-wasm.src}/cbits_test cbits_test
    pushd cbits_test
    chmod +w .
    HOME=$TMPDIR ./test.sh
    popd
    touch $out
  ''
