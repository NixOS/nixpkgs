{ stdenv
, lib
, sage-with-env
, makeWrapper
, files ? null # "null" means run all tests
, longTests ? true # run tests marked as "long time"
}:

# for a quick test of some source files:
# nix-build -E 'with (import ./. {}); sage.tests.override { files = [ "src/sage/misc/cython.py" ];}'

let
  src = sage-with-env.env.lib.src;
  runAllTests = files == null;
  testArgs = if runAllTests then "--all" else testFileList;
  patienceSpecifier = if longTests then "--long" else "";
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

    # "--long" tests are in the order of 1h, without "--long" its 1/2h
    "sage" -t --timeout=0 --nthreads "$NIX_BUILD_CORES" --optional=sage ${patienceSpecifier} ${testArgs}
  '';
}
