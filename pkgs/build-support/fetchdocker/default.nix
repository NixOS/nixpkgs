{ stdenv, lib, coreutils, bash, gnutar, writeText }:
let
  stripScheme =
    builtins.replaceStrings [ "https://" "http://" ] [ "" "" ];
  stripNixStore =
    s: lib.removePrefix "/nix/store/" s;
in
{ name
, registry         ? "https://registry-1.docker.io/v2/"
, repository       ? "library"
, imageName
, tag
, imageLayers
, imageConfig
, image            ? "${stripScheme registry}/${repository}/${imageName}:${tag}"
}:

# Make sure there are *no* slashes in the repository or container
# names since we use these to make the output derivation name for the
# nix-store path.
assert null == lib.findFirst (c: "/"==c) null (lib.stringToCharacters repository);
assert null == lib.findFirst (c: "/"==c) null (lib.stringToCharacters imageName);

let
  # Abuse paths to collapse possible double slashes
  repoTag0 = builtins.toString (/. + "/${stripScheme registry}/${repository}/${imageName}");
  repoTag1 = lib.removePrefix "/" repoTag0;

  layers = builtins.map stripNixStore imageLayers;

  manifest =
    writeText "manifest.json" (builtins.toJSON [
      { Config   = stripNixStore imageConfig;
        Layers   = layers;
        RepoTags = [ "${repoTag1}:${tag}" ];
      }]);

  repositories =
    writeText "repositories" (builtins.toJSON {
      "${repoTag1}" = {
        "${tag}" = lib.last layers;
      };
    });

  imageFileStorePaths =
    writeText "imageFileStorePaths.txt"
      (lib.concatStringsSep "\n" ((lib.unique imageLayers) ++ [imageConfig]));
in
stdenv.mkDerivation {
  builder     = ./fetchdocker-builder.sh;
  buildInputs = [ coreutils ];
  preferLocalBuild = true;

  inherit name imageName repository tag;
  inherit bash gnutar manifest repositories;
  inherit imageFileStorePaths;

  passthru = {
    inherit image;
  };
}
