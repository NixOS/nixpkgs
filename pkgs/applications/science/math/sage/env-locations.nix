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

# Various environment variables to tell sage where the files its looking for
# are located.
{
  "GP_DATA_DIR" = "${pari_data}/share/pari";
  "PARI_DATA_DIR" = "${pari_data}";
  "GPHELP" = "${pari}/bin/gphelp";
  "GPDOCDIR" = "${pari}/share/pari/doc";
  "SINGULARPATH" = "${singular}/share/singular";
  "SINGULAR_SO" = "${singular}/lib/libSingular.so";
  "SINGULAR_EXECUTABLE" = "${singular}/bin/Singular";
  "MAXIMA_FAS" = "${maxima-ecl}/lib/maxima/${maxima-ecl.version}/binary-ecl/maxima.fas";
  "MAXIMA_PREFIX" = "${maxima-ecl}";
  "CONWAY_POLYNOMIALS_DATA_DIR" = "${conway_polynomials}/share/conway_polynomials";
  "GRAPHS_DATA_DIR" = "${graphs}/share/graphs";
  "ELLCURVE_DATA_DIR" = "${elliptic_curves}/share/ellcurves";
  "POLYTOPE_DATA_DIR" = "${polytopes_db}/share/reflexive_polytopes";
  "GAP_ROOT_DIR" = "${gap}/share/gap/build-dir";
  "ECLDIR" = "${ecl}/lib/ecl-${ecl.version}/";
  "COMBINATORIAL_DESIGN_DATA_DIR" = "${combinatorial_designs}/share/combinatorial_designs";
  "CREMONA_MINI_DATA_DIR" = "${elliptic_curves}/share/cremona";
  "JMOL_DIR" = "${jmol}/share/jmol"; # point to the directory that contains JmolData.jar
  "JSMOL_DIR" = "${jmol}/share/jsmol";
  "MATHJAX_DIR" = "${mathjax}/lib/node_modules/mathjax";
  "THREEJS_DIR" = "${three}/lib/node_modules/three";
  "SAGE_INCLUDE_DIRECTORIES" = "${cysignals}/lib/python2.7/site-packages";
}
