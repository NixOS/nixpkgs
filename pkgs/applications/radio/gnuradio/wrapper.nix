{ symlinkJoin
, unwrapped
, makeWrapper
, file
, python
, extraPythonPackages ? []
, extraPaths ? []
}:

symlinkJoin rec {
  name = "${unwrapped.name}-wrapped";
  paths = [ unwrapped ] ++ extraPaths;
  # TODO:
  # Try to build unwrapped with propagatedBuildInputs = [ pythonEnv ] and test
  # if the unwrapped.pythonEnv is still not different then this pythonEnv
  # This is the real environment that'll be when shebanging the scripts
  pythonEnv = python.buildEnv.override { 
    extraLibs = unwrapped.pythonEnvInputs ++ extraPythonPackages;
    postBuild = ''
      ln -s ${unwrapped}/${python.sitePackages}/* -t $out/${python.sitePackages}
    '';
  };
  nativeBuildInputs = [ makeWrapper pythonEnv file ];
  passthru = {
    inherit unwrapped;
  };

  postBuild = ''
    # Here just to make sure they are different
    echo unwrapped python ${unwrapped.pythonEnv}
    echo our python is ${pythonEnv}
    for bin in $out/bin/*; do
      # we patch only text files in $out/bin
      if [[ "$(file -L --mime-type --brief "$bin")" =~ "text/" ]]; then
        # we can't patch them if they are read only links
        cp -L "$bin" $bin.tmp
        # replace the python intereter that was used originally in the unwrapped version
        sed -i s,${unwrapped.pythonEnv},${pythonEnv},g "$bin".tmp
        # This will used what's in pythonEnv, not unwrapped.pythonEnv
        patchShebangs $bin.tmp
        mv -f $bin.tmp $bin
      fi
    done
  '';

  inherit (unwrapped) meta;
}
