# Given a list of path-like strings, check some properties of the path library
# using those paths and return a list of attribute sets of the following form:
#
#     { <string> = <lib.path.subpath.normalise string>; }
#
# If `normalise` fails to evaluate, the attribute value is set to `""`.
# If not, the resulting value is normalised again and an appropriate attribute set added to the output list.
{
  # The path to the nixpkgs lib to use
  libpath,
  # A flat directory containing files with randomly-generated
  # path-like values
  dir,
}:
let
  lib = import libpath;

  # read each file into a string
  strings = map (name:
    builtins.readFile (dir + "/${name}")
  ) (builtins.attrNames (builtins.readDir dir));

  inherit (lib.path.subpath) normalise isValid;
  inherit (lib.asserts) assertMsg;

  normaliseAndCheck = str:
    let
      originalValid = isValid str;

      tryOnce = builtins.tryEval (normalise str);
      tryTwice = builtins.tryEval (normalise tryOnce.value);

      absConcatOrig = /. + ("/" + str);
      absConcatNormalised = /. + ("/" + tryOnce.value);
    in
      # Check the lib.path.subpath.normalise property to only error on invalid subpaths
      assert assertMsg
        (originalValid -> tryOnce.success)
        "Even though string \"${str}\" is valid as a subpath, the normalisation for it failed";
      assert assertMsg
        (! originalValid -> ! tryOnce.success)
        "Even though string \"${str}\" is invalid as a subpath, the normalisation for it succeeded";

      # Check normalisation idempotency
      assert assertMsg
        (originalValid -> tryTwice.success)
        "For valid subpath \"${str}\", the normalisation \"${tryOnce.value}\" was not a valid subpath";
      assert assertMsg
        (originalValid -> tryOnce.value == tryTwice.value)
        "For valid subpath \"${str}\", normalising it once gives \"${tryOnce.value}\" but normalising it twice gives a different result: \"${tryTwice.value}\"";

      # Check that normalisation doesn't change a string when appended to an absolute Nix path value
      assert assertMsg
        (originalValid -> absConcatOrig == absConcatNormalised)
        "For valid subpath \"${str}\", appending to an absolute Nix path value gives \"${absConcatOrig}\", but appending the normalised result \"${tryOnce.value}\" gives a different value \"${absConcatNormalised}\"";

      # Return an empty string when failed
      if tryOnce.success then tryOnce.value else "";

in lib.genAttrs strings normaliseAndCheck
