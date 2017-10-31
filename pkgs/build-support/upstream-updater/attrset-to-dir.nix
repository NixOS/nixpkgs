a :  
a.stdenv.mkDerivation rec {
  buildCommand = ''
    mkdir -p "$out/attributes"
    
  '' + (a.lib.concatStrings (map
    (n: ''
      ln -s "${a.writeTextFile {name=n; text=builtins.getAttr n a.theAttrSet;}}" $out/attributes/${n};
    '')
    (builtins.attrNames a.theAttrSet)
  ));

  name = "attribute-set";
  meta = {
    description = "Contents of an attribute set";
    maintainers = [
      a.lib.maintainers.raskin
    ];
  };
}
