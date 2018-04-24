{ stdenv
, makeWrapper
, sage
, sage-src
, sagedoc
, withDoc
}:

stdenv.mkDerivation rec {
  version = sage.version;
  name = "sage-wrapper-${version}";

  buildInputs = [
    makeWrapper
  ];

  unpackPhase = "#do nothing";
  configurePhase = "#do nothing";
  buildPhase = "#do nothing";

  installPhase = ''
    mkdir -p "$out/bin"
    makeWrapper "${sage}/bin/sage" "$out/bin/sage" \
      --set SAGE_DOC_SRC_OVERRIDE "${sage-src}/src/doc" ${
      stdenv.lib.optionalString withDoc "--set SAGE_DOC_OVERRIDE ${sagedoc}/share/doc/sage"
    }
  '';

  doInstallCheck = withDoc;
  installCheckPhase = ''
    export HOME="$TMPDIR/sage-home"
    mkdir -p "$HOME"
    "$out/bin/sage" -c 'browse_sage_doc._open("reference", testing=True)'
  '';

  meta = with stdenv.lib; {
    description = "Open Source Mathematics Software, free alternative to Magma, Maple, Mathematica, and Matlab";
    license = licenses.gpl2;
    maintainers = with maintainers; [ timokau ];
  };
}
