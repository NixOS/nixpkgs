/*
  `dhallToNix` is a utility function to convert expressions in the Dhall
   configuration language to their corresponding Nix expressions.

   Example:
     dhallToNix "{ foo = 1, bar = True }"
     => { foo = 1; bar = true; }
     dhallToNix "λ(x : Bool) → x == False"
     => x : x == false
     dhallToNix "λ(x : Bool) → x == False" false
     => true

   See https://hackage.haskell.org/package/dhall-nix/docs/Dhall-Nix.html for
   a longer tutorial

   Note that this uses "import from derivation", meaning that Nix will perform
   a build during the evaluation phase if you use this `dhallToNix` utility
*/
{
  stdenv,
  dhall-nix,
  writeText,
}:

let
  dhallToNix =
    code:
    let
      file = writeText "dhall-expression" code;

      drv = stdenv.mkDerivation {
        name = "dhall-compiled.nix";

        buildCommand = ''
          dhall-to-nix <<< "${file}" > $out
        '';

        buildInputs = [ dhall-nix ];
      };

    in
    import drv;
in
dhallToNix
