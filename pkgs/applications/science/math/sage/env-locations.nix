{ writeTextFile
, pari_data
, pari
, singular
, maxima-ecl
, conway_polynomials
, graphs
, elliptic_curves
, polytopes_db
, gap
, ecl
, combinatorial_designs
, jmol
, mathjax
, three
, cysignals
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
    export GAP_SO='${gap}/lib/libgap.so'
    export SINGULAR_EXECUTABLE='${singular}/bin/Singular'
    export MAXIMA_FAS='${maxima-ecl}/lib/maxima/${maxima-ecl.version}/binary-ecl/maxima.fas'
    export MAXIMA_PREFIX="${maxima-ecl}"
    export CONWAY_POLYNOMIALS_DATA_DIR='${conway_polynomials}/share/conway_polynomials'
    export GRAPHS_DATA_DIR='${graphs}/share/graphs'
    export ELLCURVE_DATA_DIR='${elliptic_curves}/share/ellcurves'
    export POLYTOPE_DATA_DIR='${polytopes_db}/share/reflexive_polytopes'
    export GAP_ROOT_DIR='${gap}/share/gap/build-dir'
    export ECLDIR='${ecl}/lib/ecl-${ecl.version}/'
    export COMBINATORIAL_DESIGN_DATA_DIR="${combinatorial_designs}/share/combinatorial_designs"
    export CREMONA_MINI_DATA_DIR="${elliptic_curves}/share/cremona"
    export JMOL_DIR="${jmol}/share/jmol" # point to the directory that contains JmolData.jar
    export JSMOL_DIR="${jmol}/share/jsmol"
    export MATHJAX_DIR="${mathjax}/lib/node_modules/mathjax"
    export THREEJS_DIR="${three}/lib/node_modules/three"
    export SAGE_INCLUDE_DIRECTORIES="${cysignals}/${cysignals.pythonModule.sitePackages}"
  '';
}
