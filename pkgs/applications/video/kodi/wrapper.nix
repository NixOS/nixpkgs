{ lib, makeWrapper, buildEnv, kodi, addons }:

let
  drvName = builtins.parseDrvName kodi.name;
in buildEnv {
  name = "${drvName.name}-with-addons-${drvName.version}";

  paths = [ kodi ] ++ addons;
  pathsToLink = [ "/share" ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    mkdir $out/bin
    for exe in kodi{,-standalone}
    do
      makeWrapper ${kodi}/bin/$exe $out/bin/$exe \
        --prefix PYTHONPATH : ${kodi.pythonPackages.makePythonPath addons} \
        --prefix KODI_HOME : $out/share/kodi \
        --prefix LD_LIBRARY_PATH ":" "${lib.makeLibraryPath
          (lib.concatMap
            (plugin: plugin.extraRuntimeDependencies or []) addons)}"
    done
  '';

  meta = kodi.meta // {
    description = kodi.meta.description
                + " (with addons: ${lib.concatMapStringsSep ", " (x: x.name) addons})";
  };
}
