{
  lib,
  stdenv,
  curl,

  # Used in `pkgs/build-support/prefer-remote-fetch/default.nix`
  preferLocalBuild ? true,
}:

let
  preferLocalBuildDefault = preferLocalBuild;
in

lib.fetchers.withNormalizedHash
  {
    hashTypes = [
      "sha1"
      "sha256"
      "sha512"
    ];
  }
  (
    {
      ipfs,
      url ? "",
      curlOpts ? "",
      outputHash,
      outputHashAlgo,
      meta ? { },
      port ? "8080",
      postFetch ? "",
      preferLocalBuild ? preferLocalBuildDefault,
    }:
    stdenv.mkDerivation {
      name = ipfs;
      builder = ./builder.sh;
      nativeBuildInputs = [ curl ];

      # New-style output content requirements.
      inherit outputHash outputHashAlgo;
      outputHashMode = "recursive";

      inherit
        curlOpts
        postFetch
        ipfs
        url
        port
        meta
        ;

      # Doing the download on a remote machine just duplicates network
      # traffic, so don't do that.
      inherit preferLocalBuild;
    }
  )
