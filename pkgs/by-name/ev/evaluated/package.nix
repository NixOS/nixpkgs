{
  lib,
  nix,
  runCommand,
  path,
}:

runCommand "evaluated"
  {
    nixpkgs = path;
    meta = {
      description = "Proof of concept of using a remote builder to evaluate the package list";
    };
  }
  ''

    ${lib.getExe nix} eval \
      --store ./store \
      --extra-experimental-features nix-command \
      -f ${./evaluator.nix} -I nixpkgs=$nixpkgs 2>&1 | tee raw.txt
      grep ':tree:' raw.txt | sed 's;^.*:tree: *\(.*\) *:tree:.*$;\1;' > $out
  ''
