{ lib
, stdenvNoCC
}:

/*
  Replaces all occurrences of `@varName@` in `src`, where `varName` is an
  attribute passed to the `substituteAll` Nix function, writing the result to a
  file in the Nix store.

  Example:

  # Writes a text file to the Nix store with contents "Hello, World!"
  substituteAll {
    src = builtins.toFile "greeting.txt" "Hello, @subject@!";
    subject = "World";
  }
*/
{ src
, name ? baseNameOf (toString src)
, dir ? null
, isExecutable ? false
, preInstall ? null
, postInstall ? null
, passthru ? { }
, meta ? { }
# The remaining arguments are the variables to replace.
, ...
}@args:

let
  variables = builtins.removeAttrs args [
    "name" "src" "dir" "isExecutable" "preInstall" "postInstall"
    "passthru" "meta"
  ];

  # { cat = "meow"; dog = "woof"; } -> [ "--subst-var-by" "cat" "meow" "--subst-var-by" "dog" "woof" ]
  substitutions = lib.foldlAttrs
    (acc: variable: replacement: acc ++ [ "--subst-var-by" variable replacement ])
    []
    variables;
in

stdenvNoCC.mkDerivation {
  builder = ./substitute-all.sh;
  inherit name src dir isExecutable preInstall postInstall passthru meta;

  substitutions = lib.toShellVar "substitutions" substitutions;
  passAsFile = [ "substitutions" ];

  preferLocalBuild = true;
  allowSubstitutes = false;
}
