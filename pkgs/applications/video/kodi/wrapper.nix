{ lib, makeWrapper, buildEnv, kodi, addons }:

let
  # linux distros are supposed to provide pillow and pycryptodome
  requiredPythonPackages = with kodi.pythonPackages; [ pillow pycryptodome] ++ addons;
in

buildEnv {
  name = "${kodi.name}-env";

  paths = [ kodi ] ++ addons;
  pathsToLink = [ "/share" ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    mkdir $out/bin
    for exe in kodi{,-standalone}
    do
      makeWrapper ${kodi}/bin/$exe $out/bin/$exe \
        --prefix PYTHONPATH : ${kodi.pythonPackages.makePythonPath requiredPythonPackages} \
        --prefix KODI_HOME : $out/share/kodi \
        --prefix LD_LIBRARY_PATH ":" "${lib.makeLibraryPath
          (lib.concatMap
            (plugin: plugin.extraRuntimeDependencies or []) addons)}"
    done
  '';
}
