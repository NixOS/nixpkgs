{ symlinkJoin
, unwrapped
, makeWrapper
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
  nativeBuildInputs = [ makeWrapper pythonEnv ];
  passthru = {
    inherit unwrapped;
  };

  postBuild = ''
    echo unwrapped python ${unwrapped.pythonEnv}
    echo our python is ${pythonEnv}
    for bin in $out/bin/*; do
      cp -L "$bin" $bin.tmp
      sed -i s,${unwrapped.pythonEnv},${pythonEnv},g "$bin".tmp
      patchShebangs $bin.tmp
      mv -f $bin.tmp $bin
    done
  '';

  inherit (unwrapped) meta;
}
