{ nix
, makeWrapper
, python3Packages
, lib
, nix-prefetch-scripts
, luarocks-nix
, lua5_1
, lua5_2
, lua5_3
, lua5_4
, pluginupdate
}:
let

  path = lib.makeBinPath [
    nix nix-prefetch-scripts luarocks-nix
  ];

  luaversions = [
    lua5_1
    lua5_2
    lua5_3
    lua5_4
  ];

in
python3Packages.buildPythonApplication {
  pname = "luarocks-packages-updater";
  version = "0.1";

  format = "other";

  nativeBuildInputs = [
    makeWrapper
    python3Packages.wrapPython
  ];
  propagatedBuildInputs = [
    python3Packages.gitpython
  ];

  dontUnpack = true;

  installPhase =
    ''
    mkdir -p $out/bin $out/lib
    cp ${./updater.py} $out/bin/luarocks-packages-updater
    cp ${pluginupdate} $out/lib/pluginupdate.py

    # wrap python scripts
    makeWrapperArgs+=( --prefix PATH : "${path}" --prefix PYTHONPATH : "$out/lib" \
      --set LUA_51 ${lua5_1} \
      --set LUA_52 ${lua5_2} \
      --set LUA_53 ${lua5_3} \
      --set LUA_54 ${lua5_4}
    )
    wrapPythonProgramsIn "$out"
  '';

  shellHook = ''
    export PYTHONPATH="maintainers/scripts:$PYTHONPATH"
    export PATH="${path}:$PATH"
  '';

  meta.mainProgram = "luarocks-packages-updater";
}


