
args : with args; 
rec {
  src = fetchurl {
    url = http://grahame.angrygoats.net/source/viewmtn/viewmtn-0.10.tgz;
    sha256 = "1c6y708xaf6pds1r6l00q7vpgfagfbnf95kqj168vw3xr3l8a4yx";
  };

  buildInputs = [python flup highlight monotone 
    cheetahTemplate makeWrapper graphviz which];
  configureFlags = [];
  makeFlags = ["PREFIX=$out"];

  /* doConfigure should be specified separately */
  phaseNames = ["doInstall" 
    (doPatchShebangs "$out/bin")
    (makeManyWrappers "$out/bin/*" 
      (pythonWrapperArguments + preservePathWrapperArguments)) 
  ];
      
  doInstall = fullDepEntry (''
    for i in dot mtn highlight; do 
        sed -e "s@/usr/bin/$i@$(which $i)@" -i config.py.example
    done
    sed -e "s@'templates/'@'$out/share/viewmtn/templates/'@" -i config.py.example

    fullOut=$(toPythonPath $out)
    
    ensureDir $fullOut
    ensureDir $out/bin
    ensureDir $out/share/viewmtn
    
    cp -r * $fullOut
    cp $fullOut/viewmtn.py $out/bin
    
    ln -s $fullOut/{AUTHORS,ChangeLog,INSTALL,LICENSE,README,TODO,config.py.example} $out/share/viewmtn
    ln -s $fullOut/templates $out/share/viewmtn/
    ln -s $fullOut/static $out/share/viewmtn/
  '') ["minInit" "defEnsureDir" "addInputs" "doUnpack"];

  name = "viewmtn-0.10";
  meta = {
    description = "Monotone web interface";
  };
}
