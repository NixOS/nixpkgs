{ stdenv
, sage-src
, sage-with-env
, sagelib
, python2
, psutil
, future
, sphinx
, sagenb
, maxima-ecl
, networkx
, scipy
, sympy
, matplotlib
, pillow
, ipykernel
, jupyter_client
, tachyon
, jmol
, ipywidgets
, typing
, cddlib
, pybrial
}:

stdenv.mkDerivation rec {
  version = sage-src.version;
  name = "sagedoc-${version}";


  # Building the documentation has many dependencies, because all documented
  # modules are imported and because matplotlib is used to produce plots.
  buildInputs = [
    sagelib
    python2
    psutil
    future
    sphinx
    sagenb
    maxima-ecl
    networkx
    scipy
    sympy
    matplotlib
    pillow
    ipykernel
    jupyter_client
    tachyon
    jmol
    ipywidgets
    typing
    cddlib
    pybrial
  ];

  unpackPhase = ''
    export SAGE_DOC_OVERRIDE="$PWD/share/doc/sage"
    export SAGE_DOC_SRC_OVERRIDE="$PWD/docsrc"

    cp -r "${sage-src}/src/doc" "$SAGE_DOC_SRC_OVERRIDE"
    chmod -R 755 "$SAGE_DOC_SRC_OVERRIDE"
  '';

  buildPhase = ''
    export SAGE_NUM_THREADS="$NIX_BUILD_CORES"
    export HOME="$TMPDIR/sage_home"
    mkdir -p "$HOME"

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
