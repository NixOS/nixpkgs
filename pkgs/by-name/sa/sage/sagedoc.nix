{
  stdenv,
  sage-with-env,
  python3,
  jupyter-kernel-specs,
}:

stdenv.mkDerivation rec {
  version = src.version;
  pname = "sagedoc";
  src = sage-with-env.env.lib.src;

  strictDeps = true;

  nativeBuildInputs = with python3.pkgs; [
    meson-python
    cython
    sphinx
  ];

  unpackPhase = ''
    export SAGE_DOC_OVERRIDE="$PWD/share/doc/sage"
    export SAGE_DOC_SRC_OVERRIDE="$PWD/docsrc"

    cp -r "${src}/src/doc" "$SAGE_DOC_SRC_OVERRIDE"
    chmod -R 755 "$SAGE_DOC_SRC_OVERRIDE"

    # Tools needed for meson to run the bootstrap script
    cp -r "${src}/tools/bootstrap-docs.py" "$SAGE_DOC_SRC_OVERRIDE"
    cp -r "${src}/build/sage_bootstrap" "$SAGE_DOC_SRC_OVERRIDE"
    chmod -R 755 "$SAGE_DOC_SRC_OVERRIDE/sage_bootstrap/env.py"
    sed "/assert/d" "${src}/build/sage_bootstrap/env.py" > "$SAGE_DOC_SRC_OVERRIDE/sage_bootstrap/env.py"
  '';

  preConfigure = ''
    cd docsrc
  '';

  buildPhase = ''
    export SAGE_ROOT="${sage-with-env.env.lib.src}"
    export PATH="${sage-with-env}/bin:$PATH"
    export HOME="$TMPDIR/sage_home"
    mkdir -p "$HOME"

    # needed to link them in the sage docs using intersphinx
    export PPLPY_DOCS=${python3.pkgs.pplpy.doc}/share/doc/pplpy

    # jupyter-sphinx calls the sagemath jupyter kernel during docbuild
    export JUPYTER_PATH=${jupyter-kernel-specs}

    meson setup $SAGE_DOC_OVERRIDE
    meson compile -C $SAGE_DOC_OVERRIDE
    sage -advanced > $SAGE_DOC_OVERRIDE/en/reference/repl/options.txt
    meson compile -C $SAGE_DOC_OVERRIDE doc-html
  '';

  enableParallelBuilding = true;

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
    grep -PRl "#.*(optional|needs).*sagemath_doc_html" ${src}/src/sage{,_docbuild} | \
      xargs ${sage-with-env}/bin/sage -t --optional=sage,sagemath_doc_html
  '';
}
