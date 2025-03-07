# This file provides a top-level function that will be used by both nixpkgs and nixos
# to generate mod directories for use at runtime by factorio.
{
  lib,
  stdenv,
  writeTextFile,
}:
let
  inherit (lib)
    flatten
    head
    optionals
    optionalString
    removeSuffix
    replaceStrings
    splitString
    unique
    ;
in
{
  mkModDirDrv =
    mods: # a list of mod derivations
    modsDatFile: # data file for mod settings
    extraModList: # extra content for mod-list.json
    let
      recursiveDeps = modDrv: [ modDrv ] ++ map recursiveDeps modDrv.deps;
      modDrvs = unique (flatten (map recursiveDeps mods));

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

  modDrv =
    { allRecommendedMods, allOptionalMods }:
    {
      src,
      name ? null,
      deps ? [ ],
      optionalDeps ? [ ],
      recommendedDeps ? [ ],
    }:
    stdenv.mkDerivation {

      inherit src;

      # Use the name of the zip, but endstrip ".zip" and possibly the querystring that gets left in by fetchurl
      name = replaceStrings [ "_" ] [ "-" ] (
        if name != null then name else removeSuffix ".zip" (head (splitString "?" src.name))
      );

      deps =
        deps ++ optionals allOptionalMods optionalDeps ++ optionals allRecommendedMods recommendedDeps;

      preferLocalBuild = true;
      buildCommand = ''
        mkdir -p $out
        srcBase=$(basename $src)
        srcBase=''${srcBase#*-}  # strip nix hash
        srcBase=''${srcBase%\?*} # strip querystring leftover from fetchurl
        cp $src $out/$srcBase
      '';
    };
}
