args : with args; 

if (! python ? db4Support) || (! python.db4Support) then 
  throw ''Python DB4 support is required for codeville.'' 
else

rec {
  src = fetchurl {
    url = http://codeville.org/download/Codeville-0.8.0.tar.gz;
    sha256 = "1p8zc4ijwcwf5bxl34n8d44mlxk1zhbpca68r93ywxqkqm2aqz37";
  };

  buildInputs = [python makeWrapper];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["installPythonPackage" (makeManyWrappers ''$out/bin/*'' ''--prefix PYTHONPATH : $(toPythonPath $out)'')];
      
  name = "codeville-0.8.0";
  meta = {
    description = "Codeville - RCS with powerful merge.";
  };
}
