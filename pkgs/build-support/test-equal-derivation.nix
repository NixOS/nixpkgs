pkgs:
let
  inherit (pkgs) lib runCommand;
in
{
  /* Checks that two packages produce the exact same build instructions.

     This can be used to make sure that a certain difference of configuration,
     such as the presence of an overlay does not cause a cache miss.
   */
  testEqualDerivation = description: a: b:
    let name =
      if a?name
      then lib.strings.sanitizeDerivationName "test-equal-derivation-${a.name}"
      else "test-equal-closure";
    in
      runCommand name {
        inherit description;
        a = builtins.unsafeDiscardOutputDependency a.drvPath or (throw "testEqualDerivation second argument must be a package");
        b = builtins.unsafeDiscardOutputDependency b.drvPath or (throw "testEqualDerivation third argument must be a package");
        nativeBuildInputs = [ pkgs.nix-diff ];
      } ''
        if [[ $a == $b ]]; then
          echo "$description"
          echo "The store paths are equal."
          touch $out
        else
          echo "$description"
          echo "However, the store paths differ:"
          echo
          echo nix-diff $a $b
          nix-diff $a $b
          false
        fi
      '';
}
