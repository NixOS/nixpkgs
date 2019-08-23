{ stdenv
, sage-with-env
, python
, maxima-ecl
, tachyon
, jmol
, cddlib
}:

stdenv.mkDerivation rec {
  version = src.version;
  name = "sagedoc-${version}";
  src = sage-with-env.env.lib.src;


  # Building the documentation has many dependencies, because all documented
  # modules are imported and because matplotlib is used to produce plots.
  buildInputs = [
    sage-with-env.env.lib
    python
    maxima-ecl
    tachyon
    jmol
    cddlib
  ] ++ (with python.pkgs; [
    psutil
    future
    sphinx
    sagenb
    scipy
    sympy
    matplotlib
    pillow
    networkx
    ipykernel
    ipywidgets
    jupyter_client
    typing
    pybrial
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
    export PPLPY_DOCS=${python.pkgs.pplpy.doc}/share/doc/pplpy

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
