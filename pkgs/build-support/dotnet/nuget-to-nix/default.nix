{ lib
, runCommandLocal
, runtimeShell
, substituteAll
, nix
, coreutils
, findutils
, gnused
, jq
, curl
, gnugrep
, xmlstarlet
}:

runCommandLocal "nuget-to-nix" {
  script = substituteAll {
    src = ./nuget-to-nix.sh;
    inherit runtimeShell;

    binPath = lib.makeBinPath [
      coreutils
      curl
      findutils
      gnugrep
      gnused
      jq
      nix
      xmlstarlet
    ];
  };

  meta.description = "Convert a nuget packages directory to a lockfile for buildDotnetModule";
} ''
  install -Dm755 $script $out/bin/nuget-to-nix
''
