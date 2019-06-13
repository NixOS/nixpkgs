{ stdenv
, lib
, sage-with-env
, makeWrapper
, files ? null # "null" means run all tests
, longTests ? true # run tests marked as "long time" (roughly doubles runtime)
# Run as many tests as possible in approximately n seconds. This will give each
# file to test a "time budget" and stop tests if it is exceeded. 300 is the
# upstream default value.
# https://trac.sagemath.org/ticket/25270 for details.
, timeLimit ? null
}:

# for a quick test of some source files:
# nix-build -E 'with (import ./. {}); sage.tests.override { files = [ "src/sage/misc/cython.py" ];}'

let
  src = sage-with-env.env.lib.src;
  runAllTests = files == null;
  testArgs = if runAllTests then "--all" else testFileList;
  patienceSpecifier = if longTests then "--long" else "";
  timeSpecifier = if timeLimit == null then "" else "--short ${toString timeLimit}";
  relpathToArg = relpath: lib.escapeShellArg "${src}/${relpath}"; # paths need to be absolute
  testFileList = lib.concatStringsSep " " (map relpathToArg files);
in
stdenv.mkDerivation rec {
  version = src.version;
  name = "sage-tests-${version}";
  inherit src;

  buildInputs = [
    makeWrapper
    sage-with-env
  ];

  unpackPhase = "#do nothing";
  configurePhase = "#do nothing";
  buildPhase = "#do nothing";

  installPhase = ''
    # This output is not actually needed for anything, the package just
    # exists to decouple the sage build from its t ests.

    mkdir -p "$out/bin"
    # Like a symlink, but make sure that $0 points to the original.
    makeWrapper "${sage-with-env}/bin/sage" "$out/bin/sage"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    export HOME="$TMPDIR/sage-home"
    mkdir -p "$HOME"

    echo "Running sage tests with arguments ${timeSpecifier} ${patienceSpecifier} ${testArgs}"
    "sage" -t --nthreads "$NIX_BUILD_CORES" --optional=sage ${timeSpecifier} ${patienceSpecifier} ${testArgs}
  '';
}
