{ stdenv
, sage-with-env
, python3
, maxima-ecl
, tachyon
, jmol
, cddlib
}:

stdenv.mkDerivation rec {
  version = src.version;
  pname = "sagedoc";
  src = sage-with-env.env.lib.src;


  # Building the documentation has many dependencies, because all documented
  # modules are imported and because matplotlib is used to produce plots.
  buildInputs = [
    sage-with-env.env.lib
    python3
    maxima-ecl
    tachyon
    jmol
    cddlib
  ] ++ (with python3.pkgs; [
    psutil
    future
    sphinx
    scipy
    sympy
    matplotlib
    pillow
    networkx
    ipykernel
    ipywidgets
    jupyter_client
  ]);

  unpackPhase = ''
    export SAGE_DOC_OVERRIDE="$PWD/share/doc/sage"
    export SAGE_DOC_SRC_OVERRIDE="$PWD/docsrc"

    cp -r "${src}/src/doc" "$SAGE_DOC_SRC_OVERRIDE"
    chmod -R 755 "$SAGE_DOC_SRC_OVERRIDE"
  '';

  postPatch = ''
    # src/doc/bootstrap generates installation instructions for
    # arch, debian, fedora, cygwin and homebrew. as a hack, disable
    # including the generated files.
    sed -i "/literalinclude/d" $SAGE_DOC_SRC_OVERRIDE/en/installation/source.rst
  '';

  buildPhase = ''
    export SAGE_NUM_THREADS="$NIX_BUILD_CORES"
    export HOME="$TMPDIR/sage_home"
    mkdir -p "$HOME"

    # needed to link them in the sage docs using intersphinx
    export PPLPY_DOCS=${python3.pkgs.pplpy.doc}/share/doc/pplpy

    # adapted from src/doc/bootstrap
    OUTPUT_DIR="$SAGE_DOC_SRC_OVERRIDE/en/reference/repl"
    mkdir -p "$OUTPUT_DIR"
    OUTPUT="$OUTPUT_DIR/options.txt"
    ${sage-with-env}/bin/sage -advanced > "$OUTPUT"

    ${sage-with-env}/bin/sage -python -m sage_setup.docbuild \
      --mathjax \
      --no-pdf-links \
      all html
  '';

  installPhase = ''
    cd "$SAGE_DOC_OVERRIDE"

    mkdir -p "$out/share/doc/sage"
    cp -r html "$out"/share/doc/sage

    # Replace duplicated files by symlinks (Gentoo)
    cd "$out"/share/doc/sage
    mv html/en/_static{,.tmp}
    for _dir in `find -name _static` ; do
          rm -r $_dir
          ln -s /share/doc/sage/html/en/_static $_dir
    done
    mv html/en/_static{.tmp,}
  '';

  doCheck = true;
  checkPhase = ''
    ${sage-with-env}/bin/sage -t --optional=dochtml --all
  '';
}
