{
  lib,
  callPackage,
  writeShellApplication,
}:
let
  assets = callPackage ./assets.nix { };
  quakec = callPackage ./quakec.nix { };
  fteqw = callPackage ./fteqw.nix { };

  # We use the youngest version of all of the dependencies as the version number.
  # This is similar to what upstream uses, except ours is a bit more accurate
  # since we don't rely on a CI to run at an arbitrary time.
  dateString =
    lib.pipe
      [
        assets
        fteqw
        quakec
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
    data=${assets.pc}

    relinkGameFiles() {
      mkdir -p "$runDir"/nzp

      # Remove existing links
      find "$runDir" -type l -exec rm {} +

      # Link game files
      ln -s $data/default.fmf "$runDir"
      ln -st "$runDir"/nzp $data/nzp/* ${quakec.fte}/*

      # Write current version
      echo "${version}" > "$runDir"/nzp/version.txt
    }

    if [[ ! -d $runDir ]]; then
      echo "Game directory $runDir not found. Assuming first launch"
      echo "Linking game files"
      relinkGameFiles
    else
      currentVersion=$(<"$runDir"/nzp/version.txt)
      if [[ "${version}" != "$currentVersion" ]]; then
        echo "Version mismatch! (saved version $currentVersion != current version ${version})"
        echo "Relinking game files"
        relinkGameFiles
      fi
    fi

    exec ${lib.getExe fteqw} -basedir "$runDir" "$@"
  '';

  derivationArgs = {
    inherit version;
    passthru = {
      updateScript = callPackage ./update.nix { };
      inherit assets quakec fteqw;
    };
  };

  meta = {
    inherit (fteqw.meta) platforms;
    description = "Call of Duty: Zombies demake, powered by various Quake sourceports (PC version)";
    homepage = "https://docs.nzp.gay";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "nzportable";
  };
}
