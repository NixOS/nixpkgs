{ lib
, doxygen
, graphviz
, texlive
, perl
, fontconfig
}:

let
  latex = texlive.combine {
    inherit (texlive)
      scheme-small
      latexmk
      tex-gyre
      fncychap
      wrapfig
      capt-of
      framed
      needspace
      tabulary
      varwidth
      titlesec
      newunicodechar;
  };
in _: prev: {
  pname = "${prev.pname}-doc";

  nativeBuildInputs = prev.nativeBuildInputs ++ [
    doxygen
    graphviz
    perl
    latex
  ];

  cmakeFlags = prev.cmakeFlags ++ [
    (lib.cmakeBool "GINKGO_BUILD_REFERENCE" false)
    (lib.cmakeBool "GINKGO_BUILD_OMP" false)
    (lib.cmakeBool "GINKGO_BUILD_MPI" false)
    (lib.cmakeBool "GINKGO_MIXED_PRECISION" false)
    (lib.cmakeBool "GINKGO_BUILD_DOC" true)
    (lib.cmakeBool "GINKGO_DOC_GENERATE_PDF" false)
    (lib.cmakeBool "GINKGO_DOC_GENERATE_DEV" true)
    (lib.cmakeBool "GINKGO_DOC_GENERATE_EXAMPLES" true)
  ];

  postPatch = prev.postPatch + ''
    export HOME=$(mktemp -d)
    export FONTCONFIG_FILE=${lib.getOutput "out" fontconfig}/etc/fonts/fonts.conf
    patchShebangs doc
  '';

  postInstall = prev.postInstall + ''
    rm -rf $out
    mkdir -p $out/share/ginkgo
    mv doc/usr $out/share/ginkgo/usr
    mv doc/dev $out/share/ginkgo/dev
    mv doc/examples $out/share/ginkgo/examples
    rm -rf $out/share/ginkgo/examples/{CMakeFiles,cmake_install.cmake,Makefile}
  '';

  passthru = {
    inherit (prev.passthru) mpi openmp;
  };
}
