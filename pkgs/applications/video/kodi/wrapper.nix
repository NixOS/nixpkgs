{
  lib,
  makeWrapper,
  buildEnv,
  kodi,
  addons,
  callPackage,
}:

let
  kodiPackages = callPackage ../../../top-level/kodi-packages.nix { inherit kodi; };

  # linux distros are supposed to provide pillow and pycryptodome
  requiredPythonPath =
    with kodi.pythonPackages;
    makePythonPath [
      pillow
      pycryptodome
    ];

  # each kodi addon can potentially export a python module which should be included in PYTHONPATH
  # see any addon which supplies `passthru.pythonPath` and the corresponding entry in the addons `addon.xml`
  # eg. `<extension point="xbmc.python.module" library="lib" />` -> pythonPath = "lib";
  additionalPythonPath =
    let
      addonsWithPythonPath = lib.filter (addon: addon ? pythonPath) addons;
    in
    lib.concatMapStringsSep ":" (
      addon: "${addon}${kodiPackages.addonDir}/${addon.namespace}/${addon.pythonPath}"
    ) addonsWithPythonPath;

  # each kodi addon can ask to add packages to the kodi PATH.
  # E.g. sendtokodi asks to add deno. See any addon that supplies `passthru.pathPackages`.
  pathPackages =
    let
      addonsHavingPathPackages = lib.filter (addon: addon ? pathPackages) addons;
    in
    lib.flatten (map (addon: addon.pathPackages) addonsHavingPathPackages);
in

buildEnv {
  name = "${kodi.name}-env";

  paths = [ kodi ] ++ addons;
  pathsToLink = [ "/share" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    mkdir $out/bin
    for exe in kodi{,-standalone}
    do
      makeWrapper ${kodi}/bin/$exe $out/bin/$exe \
        --prefix PYTHONPATH : ${requiredPythonPath}:${additionalPythonPath} \
        --prefix PATH : ${lib.makeBinPath pathPackages} \
        --prefix KODI_HOME : $out/share/kodi \
        --prefix LD_LIBRARY_PATH ":" "${
          lib.makeLibraryPath (lib.concatMap (plugin: plugin.extraRuntimeDependencies or [ ]) addons)
        }"
    done
  '';
}
