{
  lib,
  runtimeShell,
  replaceVarsWith,
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

replaceVarsWith {
  name = "nuget-to-nix";
  dir = "bin";

  src = ./nuget-to-nix.sh;
  isExecutable = true;

  replacements = {
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
  };

  meta = {
    description = "Convert a nuget packages directory to a lockfile for buildDotnetModule";
    mainProgram = "nuget-to-nix";
  };
}
