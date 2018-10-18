{ stdenv, lib, makeWrapper, buildEnv, kodi, plugins }:

buildEnv {
  name = "kodi-with-plugins-${(builtins.parseDrvName kodi.name).version}";

  paths = [ kodi ] ++ plugins;
  pathsToLink = [ "/share" ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    mkdir $out/bin
    for exe in kodi{,-standalone}
    do
      makeWrapper ${kodi}/bin/$exe $out/bin/$exe \
        --prefix PYTHONPATH : ${kodi.pythonPackages.makePythonPath plugins} \
        --prefix KODI_HOME : $out/share/kodi
    done
  '';

  meta = kodi.meta // {
    description = kodi.meta.description
                + " (with plugins: ${lib.concatMapStringsSep ", " (x: x.name) plugins})";
  };
}
