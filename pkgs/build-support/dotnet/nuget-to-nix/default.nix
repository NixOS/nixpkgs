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
}:

runCommandLocal "nuget-to-nix" {
  script = substituteAll {
    src = ./nuget-to-nix.sh;
    inherit runtimeShell;

    binPath = lib.makeBinPath [
      nix
      coreutils
      findutils
      gnused
      jq
      curl
    ];
  };

  meta.description = "Convert a nuget packages directory to a lockfile for buildDotnetModule";
} ''
  install -Dm755 $script $out/bin/nuget-to-nix
''
