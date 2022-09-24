{ lib
, runCommandLocal
, runtimeShell
, substituteAll
, coreutils
, findutils
, unzip
, zip
}:

runCommandLocal "canonicalize-nupkg" {
  script = substituteAll {
    src = ./canonicalize-nupkg.sh;
    inherit runtimeShell;

    binPath = lib.makeBinPath [
      coreutils
      findutils
      unzip
      zip
    ];
  };

  meta.description = "Create a canonical version of a nupkgs, so it can be downloaded from any source";
} ''
  install -Dm755 $script $out/bin/canonicalize-nupkg
''
