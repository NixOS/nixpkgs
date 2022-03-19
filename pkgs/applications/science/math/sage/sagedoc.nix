{ stdenv
, sage-with-env
, python3
, jupyter-kernel-specs
, maxima
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
    maxima
    tachyon
    jmol
    cddlib
  ] ++ (with python3.pkgs; [
    sage-docbuild
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
    jupyter-client
  ]);

  unpackPhase = ''
    export SAGE_DOC_OVERRIDE="$PWD/share/doc/sage"
    export SAGE_DOC_SRC_OVERRIDE="$PWD/docsrc"

    cp -r "${src}/src/doc" "$SAGE_DOC_SRC_OVERRIDE"
    chmod -R 755 "$SAGE_DOC_SRC_OVERRIDE"
  '';

  buildPhase = ''
    export SAGE_NUM_THREADS="$NIX_BUILD_CORES"
    export HOME="$TMPDIR/sage_home"
    mkdir -p "$HOME"

    # needed to link them in the sage docs using intersphinx
    export PPLPY_DOCS=${python3.pkgs.pplpy.doc}/share/doc/pplpy

    # adapted from src/doc/bootstrap (which we don't run)
    OUTPUT_DIR="$SAGE_DOC_SRC_OVERRIDE/en/reference/repl"
    mkdir -p "$OUTPUT_DIR"
    OUTPUT="$OUTPUT_DIR/options.txt"
    ${sage-with-env}/bin/sage -advanced > "$OUTPUT"

    # jupyter-sphinx calls the sagemath jupyter kernel during docbuild
    export JUPYTER_PATH=${jupyter-kernel-specs}

    # sage --docbuild unsets JUPYTER_PATH, so we call sage_docbuild directly
    # https://trac.sagemath.org/ticket/33650#comment:32
    ${sage-with-env}/bin/sage --python3 -m sage_docbuild \
      --mathjax \
      --no-pdf-links \
      all html < /dev/null
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
          ln -rs html/en/_static $_dir
    done
    mv html/en/_static{.tmp,}
  '';

  doCheck = true;
  checkPhase = ''
    # sagemath_doc_html tests assume sage tests are being run, so we
    # compromise: we run standard tests, but only on files containing
    # relevant tests. as of Sage 9.6, there are only 4 such files.
    grep -PRl "#.*optional.*sagemath_doc_html" ${src}/src/sage{,_docbuild} | \
      xargs ${sage-with-env}/bin/sage -t --optional=sage,sagemath_doc_html
  '';
}
