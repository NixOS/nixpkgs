{
  lib,
  runtimeShell,
  substituteAll,
  nix,
  coreutils,
  jq,
  xmlstarlet,
  curl,
  gnugrep,
  gawk,
  nuget-to-json,
  cacert,
}:

substituteAll {
  name = "nuget-to-nix";
  dir = "bin";

  src = ./nuget-to-nix.sh;
  isExecutable = true;

  inherit runtimeShell cacert;
  binPath = lib.makeBinPath [
    nix
    coreutils
    jq
    xmlstarlet
    curl
    gnugrep
    gawk
    nuget-to-json
  ];

  meta = {
    description = "Convert a nuget packages directory to a lockfile for buildDotnetModule";
    mainProgram = "nuget-to-nix";
  };
}
