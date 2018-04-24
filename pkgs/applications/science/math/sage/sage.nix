{ stdenv
, sage-with-env
, makeWrapper
}:

stdenv.mkDerivation rec {
  version = sage-with-env.version;
  name = "sage-${version}";

  buildInputs = [
    makeWrapper
  ];

  unpackPhase = "#do nothing";
  configurePhase = "#do nothing";
  buildPhase = "#do nothing";

  installPhase = ''
    mkdir -p "$out/bin"
    # Like a symlink, but make sure that $0 points to the original.
    makeWrapper "${sage-with-env}/bin/sage" "$out/bin/sage"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    export HOME="$TMPDIR/sage-home"
    mkdir -p "$HOME"

    # "--long" tests are in the order of 1h, without "--long" its 1/2h
    "$out/bin/sage" -t --nthreads "$NIX_BUILD_CORES" --optional=sage --long --all
  '';
}
