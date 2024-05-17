{
  lib,
  callPackage,
  writeShellApplication,
  nzp-assets,
  nzp-fteqw,
  nzp-quakec,
}:
let
  # We use the youngest version of all of the dependencies as the version number.
  # This is similar to what upstream uses, except ours is a bit more accurate
  # since we don't rely on a CI to run at an arbitrary time.
  dateString =
    lib.pipe
      [
        nzp-assets
        nzp-fteqw
        nzp-quakec
      ]
      [
        # Find the youngest (most recently updated) version
        (lib.foldl' (acc: p: if lib.versionOlder acc p.version then p.version else acc) "")
        (lib.splitString "-")
        (lib.sublist 2 6) # drop the first two segments (0 and unstable) and only keep the date
        lib.concatStrings
      ];

  version = "2.0.0-indev+${dateString}";
in
writeShellApplication {
  name = "nzportable";

  text = ''
    runDir=''${XDG_DATA_HOME:-$HOME/.local/share}/nzportable
    data=${nzp-assets}/pc

    relinkGameFiles() {
      # Remove existing links
      find "$runDir" -type l -exec rm {} \;

      # Link game files
      ln -s $data/default.fmf "$runDir"
      # Exempt fte.cfg since the game must be able to write to it and symlinks don't work
      find $data/nzp -mindepth 1 -maxdepth 1 ! -name "fte.cfg" -exec ln -s {} "$runDir"/nzp \;

      ln -s ${nzp-quakec.fte}/* "$runDir"/nzp

      # Write current version
      echo "${version}" > "$runDir"/nzp/version.txt
    }

    if [[ ! -d $runDir ]]; then
      echo "Game directory $runDir not found. Assuming first launch"
      echo "Linking game files"

      mkdir -p "$runDir"/nzp
      relinkGameFiles

      echo "Creating default config"
      install -m644 $data/nzp/fte.cfg "$runDir"/nzp
    else
      currentVersion=$(<"$runDir"/nzp/version.txt)
      if [[ "${version}" != "$currentVersion" ]]; then
        echo "Version mismatch! (saved version $currentVersion != current version ${version})"
        echo "Relinking game files"
        relinkGameFiles
      fi
    fi

    exec ${lib.getExe nzp-fteqw} -basedir "$runDir" "$@"
  '';

  derivationArgs = {
    inherit version;
    passthru.nzp-update = callPackage ./update.nix;
  };

  meta = {
    inherit (nzp-fteqw.meta) platforms;
    description = "Call of Duty: Zombies demake, powered by various Quake sourceports (PC version)";
    longDescription = ''
      The PC port is powered by a fork of the FTEQW engine, which supports several graphics options.
      You can specify those graphics option by overriding the FTEQW dependency, like this:
      ```nix
        nzportable.override {
          nzp-fteqw = nzp-fteqw.override {
            enableVulkan = true;
          };
        }
      ```
      And in the game, you need to run `setrenderer <renderer>` to change the current renderer.
      Run `setrenderer` without any arguments to view the list of available renderers.

      Supported graphics options are as follows:
      - `enableEGL`: Enable the OpenGL ES renderer (`egl`). Enabled by default.
      - `enableVulkan`: Enable the Vulkan renderer (`xvk`). Enabled by default.
      - `enableWayland`: Enable native Wayland support, instead of using X11.
        Adds up to two renderers, based on whether EGL and Vulkan are installed: `wlgl` and `wlvk`.
        Seems to be currently broken and currently not enabled by default.
    '';
    homepage = "https://docs.nzp.gay";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "nzportable";
  };
}
