{ stdenv
, makeWrapper
, sage-tests
, sage-with-env
, sagedoc
, withDoc
}:

# A wrapper that makes sure sage finds its docs (if they were build).

stdenv.mkDerivation rec {
  version = src.version;
  name = "sage-${version}";
  src = sage-with-env.env.lib.src;

  buildInputs = [
    makeWrapper

    # This is a hack to make sure sage-tests is evaluated. It doesn't acutally
    # produce anything of value, it just decouples the tests from the build.
    sage-tests
  ];

  unpackPhase = "#do nothing";
  configurePhase = "#do nothing";
  buildPhase = "#do nothing";

  installPhase = ''
    mkdir -p "$out/bin"
    makeWrapper "${sage-with-env}/bin/sage" "$out/bin/sage" \
      --set SAGE_DOC_SRC_OVERRIDE "${src}/src/doc" ${
      stdenv.lib.optionalString withDoc "--set SAGE_DOC_OVERRIDE ${sagedoc}/share/doc/sage"
    }
  '';

  doInstallCheck = withDoc;
  installCheckPhase = ''
    export HOME="$TMPDIR/sage-home"
    mkdir -p "$HOME"
    "$out/bin/sage" -c 'browse_sage_doc._open("reference", testing=True)'
  '';

  passthru = {
    tests = sage-tests;
    doc = sagedoc;
    lib = sage-with-env.env.lib;
  };

  meta = with stdenv.lib; {
    description = "Open Source Mathematics Software, free alternative to Magma, Maple, Mathematica, and Matlab";
    license = licenses.gpl2;
    maintainers = with maintainers; [ timokau ];
  };
}
