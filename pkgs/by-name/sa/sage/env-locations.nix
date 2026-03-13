{
  writeTextFile,
  pari_data,
  pari,
  singular,
  maxima,
  graphs,
  elliptic_curves,
  polytopes_db,
  gap,
  combinatorial_designs,
  mathjax,
  three,
  cysignals,
}:

# A bash script setting various environment variables to tell sage where
# the files its looking fore are located. Also see `sage-env`.
writeTextFile rec {
  name = "sage-env-locations";
  destination = "/${name}";
  text = ''
    export GP_DATA_DIR="${pari_data}/share/pari"
    export PARI_DATA_DIR="${pari_data}"
    export GPHELP="${pari}/bin/gphelp"
    export GPDOCDIR="${pari}/share/pari/doc"
    export SINGULARPATH='${singular}/share/singular'
    export SINGULAR_SO='${singular}/lib/libSingular.so'
    export SINGULAR_EXECUTABLE='${singular}/bin/Singular'
    export MAXIMA_FAS='${maxima}/lib/maxima/${maxima.version}/binary-ecl/maxima.fas'
    export MAXIMA_PREFIX="${maxima}"
    export GRAPHS_DATA_DIR='${graphs}/share/graphs'
    export ELLCURVE_DATA_DIR='${elliptic_curves}/share/ellcurves'
    export POLYTOPE_DATA_DIR='${polytopes_db}/share/reflexive_polytopes'
    export GAP_ROOT_PATHS='${gap}/lib/gap;${gap}/share/gap'
    export ECLDIR='${maxima.lisp-compiler}/lib/${maxima.lisp-compiler.pname}-${maxima.lisp-compiler.version}/'
    export COMBINATORIAL_DESIGN_DATA_DIR="${combinatorial_designs}/share/combinatorial_designs"
    export CREMONA_MINI_DATA_DIR="${elliptic_curves}/share/cremona"
    export MATHJAX_DIR="${mathjax}/lib/node_modules/mathjax"
    export THREEJS_DIR="${three}/lib/node_modules/three"
    export SAGE_INCLUDE_DIRECTORIES="${cysignals}/${cysignals.pythonModule.sitePackages}"
  '';
}
