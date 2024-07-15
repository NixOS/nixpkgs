{ lib
, runCommandLocal
, runtimeShell
, substituteAll
, nix
, coreutils
, jq
, yq
, curl
, gnugrep
, gawk
, zip
, dotnet-sdk
}:

runCommandLocal "nuget-to-nix" {
  script = substituteAll {
    src = ./nuget-to-nix.sh;
    inherit runtimeShell;

    binPath = lib.makeBinPath [
      nix
      coreutils
      jq
      yq
      curl
      gnugrep
      gawk
      dotnet-sdk
      zip
    ];
  };

  meta.description = "Convert a nuget packages directory to a lockfile for buildDotnetModule";
} ''
  install -Dm755 $script $out/bin/nuget-to-nix
''
