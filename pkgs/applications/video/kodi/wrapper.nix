{ stdenv, lib, makeWrapper, buildEnv, kodi, plugins }:

let
  drvName = builtins.parseDrvName kodi.name;
in buildEnv {
  name = "${drvName.name}-with-plugins-${drvName.version}";

  paths = [ kodi ] ++ plugins;
  pathsToLink = [ "/share" ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    mkdir $out/bin
    for exe in kodi{,-standalone}
    do
      makeWrapper ${kodi}/bin/$exe $out/bin/$exe \
        --prefix PYTHONPATH : ${kodi.pythonPackages.makePythonPath plugins} \
        --prefix KODI_HOME : $out/share/kodi \
        --prefix LD_LIBRARY_PATH ":" "${lib.makeLibraryPath
          (stdenv.lib.concatMap
            (plugin: plugin.extraRuntimeDependencies) plugins)}"
    done
  '';

  meta = kodi.meta // {
    description = kodi.meta.description
                + " (with plugins: ${lib.concatMapStringsSep ", " (x: x.name) plugins})";
  };
}
