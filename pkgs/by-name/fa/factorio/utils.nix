# This file provides a top-level function that will be used by both nixpkgs and nixos
# to generate mod directories for use at runtime by factorio.
{
  lib,
  stdenv,
  writeTextFile,
  fetchurl,
}:
let
  inherit (lib)
    flatten
    optionalString
    unique
    ;
in
{
  mkModDirDrv =
    mods: # a list of mod derivations
    modsDatFile: # data file for mod settings
    extraModList: # extra content for mod-list.json
    let
      modDrvs = unique (flatten mods);

      modList = map (mod: {
        name = mod.pname;
        enabled = true;
      }) modDrvs;
      modListDrv = writeTextFile {
        name = "mod-list.json";
        text = builtins.toJSON { mods = modList ++ extraModList; };
      };
    in
    stdenv.mkDerivation {
      name = "factorio-mod-directory";

      preferLocalBuild = true;
      buildCommand =
        ''
          mkdir -p $out
          for modDrv in ${toString modDrvs}; do
            # NB: there will only ever be a single zip file in each mod derivation's output dir
            ln -s $modDrv/*.zip $out
          done
          cp ${toString modListDrv} $out/mod-list.json
        ''
        + (optionalString (modsDatFile != null) ''
          cp ${modsDatFile} $out/mod-settings.dat
        '');
    };

  modsFromLock =
    lockFile:
    let
      lock = builtins.fromJSON (builtins.readFile lockFile);
      downloadMod =
        {
          name,
          version,
          download_url,
          file_name,
          sha1,
        }:
        let
          # It is up to the user to tell curl how to authenticate against mods.factorio.com.
          # The easiest way is to prefetch the file.
          src = fetchurl {
            name = file_name;
            url = "https://mods.factorio.com${download_url}";
            inherit sha1;
          };

          mod = stdenv.mkDerivation {
            inherit src;
            name = "${name}-${version}";
            pname = name;
            inherit version;
            preferLocalBuild = true;
            buildCommand = ''
              mkdir -p $out
              ln -s $src $out/${file_name}
            '';
          };

        in
        mod;
    in
    map downloadMod lock;
}
