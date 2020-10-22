{ stdenv
, makeWrapper
, sage-tests
, sage-with-env
, jupyter-kernel-definition
, jupyter-kernel
, sagedoc
, withDoc
}:

# A wrapper that makes sure sage finds its docs (if they were build) and the
# jupyter kernel spec.

let
  # generate kernel spec + default kernels
  kernel-specs = jupyter-kernel.create {
    definitions = jupyter-kernel.default // {
      sagemath = jupyter-kernel-definition;
    };
  };
in
stdenv.mkDerivation rec {
  version = src.version;
  pname = "sage";
  src = sage-with-env.env.lib.src;

  buildInputs = [
    makeWrapper

    # This is a hack to make sure sage-tests is evaluated. It doesn't acutally
    # produce anything of value, it just decouples the tests from the build.
    sage-tests
  ];

  dontUnpack = true;
  configurePhase = "#do nothing";
  buildPhase = "#do nothing";

  installPhase = ''
    mkdir -p "$out/bin"
    makeWrapper "${sage-with-env}/bin/sage" "$out/bin/sage" \
      --set SAGE_DOC_SRC_OVERRIDE "${src}/src/doc" ${
        stdenv.lib.optionalString withDoc "--set SAGE_DOC_OVERRIDE ${sagedoc}/share/doc/sage"
      } \
      --prefix JUPYTER_PATH : "${kernel-specs}"
  '';

  doInstallCheck = withDoc;
  installCheckPhase = ''
    export HOME="$TMPDIR/sage-home"
    mkdir -p "$HOME"
    "$out/bin/sage" -c 'browse_sage_doc._open("reference", testing=True)'
  '';

  passthru = {
    tests = sage-tests;
    quicktest = sage-tests.override { longTests = false; timeLimit = 600; }; # as many tests as possible in ~10m
    doc = sagedoc;
    lib = sage-with-env.env.lib;
    kernelspec = jupyter-kernel-definition;
  };

  meta = with stdenv.lib; {
    description = "Open Source Mathematics Software, free alternative to Magma, Maple, Mathematica, and Matlab";
    license = licenses.gpl2;
    maintainers = teams.sage.members;
  };
}
