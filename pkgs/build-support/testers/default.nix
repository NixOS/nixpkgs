{ pkgs, lib, callPackage, runCommand }:
# Documentation is in doc/builders/testers.chapter.md
{
  testEqualDerivation = callPackage ./test-equal-derivation.nix { };

  testVersion =
    { package,
      command ? "${package.meta.mainProgram or package.pname or package.name} --version",
      version ? package.version,
    }: runCommand "${package.name}-test-version" { nativeBuildInputs = [ package ]; meta.timeout = 60; } ''
      if output=$(${command} 2>&1); then
        grep -Fw "${version}" - <<< "$output"
        touch $out
      else
        echo "$output" >&2 && exit 1
      fi
    '';

  # See doc/builders/testers.chapter.md or
  # https://nixos.org/manual/nixpkgs/unstable/#tester-invalidateFetcherByDrvHash
  invalidateFetcherByDrvHash = f: args:
    let
      drvPath = (f args).drvPath;
      # It's safe to discard the context, because we don't access the path.
      salt = builtins.unsafeDiscardStringContext (lib.substring 0 12 (baseNameOf drvPath));
      # New derivation incorporating the original drv hash in the name
      salted = f (args // { name = "${args.name or "source"}-salted-${salt}"; });
      # Make sure we did change the derivation. If the fetcher ignores `name`,
      # `invalidateFetcherByDrvHash` doesn't work.
      checked =
        if salted.drvPath == drvPath
        then throw "invalidateFetcherByDrvHash: Adding the derivation hash to the fixed-output derivation name had no effect. Make sure the fetcher's name argument ends up in the derivation name. Otherwise, the fetcher will not be re-run when its implementation changes. This is important for testing."
        else salted;
    in checked;

}
