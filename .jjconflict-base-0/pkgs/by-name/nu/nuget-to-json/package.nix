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
  cacert,
}:

replaceVarsWith {
  name = "nuget-to-json";
  dir = "bin";

  src = ./nuget-to-json.sh;
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
    ];
  };

  meta = {
    description = "Convert a nuget packages directory to a lockfile for buildDotnetModule";
    mainProgram = "nuget-to-json";
  };
}
