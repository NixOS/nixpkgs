{
  symlinkJoin,
  lib,
  makeWrapper,
  folder-color-switcher,
  nemo,
  nemo-emblems,
  nemo-fileroller,
  nemo-python,
  python3,
  extensions ? [ ],
  useDefaultExtensions ? true,
}:

let
  selectedExtensions =
    extensions
    ++ lib.optionals useDefaultExtensions [
      # We keep this in sync with a default Mint installation
      # Right now (only) nemo-share is missing
      folder-color-switcher
      nemo-emblems
      nemo-fileroller
      nemo-python
    ];
  nemoPythonExtensionsDeps = lib.concatMap (x: x.nemoPythonExtensionDeps or [ ]) selectedExtensions;
in
symlinkJoin {
  name = "nemo-with-extensions-${nemo.version}";

  paths = [ nemo ] ++ selectedExtensions;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    for f in $(find $out/bin/ $out/libexec/ -type l -not -path "*/.*"); do
      wrapProgram "$f" \
        --set "NEMO_EXTENSION_DIR" "$out/${nemo.extensiondir}" \
        --set "NEMO_PYTHON_EXTENSION_DIR" "$out/share/nemo-python/extensions" \
        --set "NEMO_PYTHON_SEARCH_PATH" "${python3.pkgs.makePythonPath nemoPythonExtensionsDeps}"
    done

    # Don't populate the same nemo actions twice when having this globally installed
    # https://github.com/NixOS/nixpkgs/issues/190781#issuecomment-1365601853
    rm -r $out/share/nemo/actions

    # Point to wrapped binary in all service files
    for file in "share/dbus-1/services/nemo.FileManager1.service" \
      "share/dbus-1/services/nemo.service"
    do
      rm "$out/$file"
      substitute "${nemo}/$file" "$out/$file" \
        --replace "${nemo}" "$out"
    done
  '';

  meta = removeAttrs nemo.meta [
    "name"
    "outputsToInstall"
    "position"
  ];
}
