{ lib, stdenv, buildEnv, buildPackages }:

# A special kind of derivation that is only meant to be consumed by the
# nix-shell.
{ name ? "nix-shell"
, # a list of packages to add to the shell environment
  packages ? [ ]
, # propagate all the inputs from the given derivations
  inputsFrom ? [ ]
, buildInputs ? [ ]
, nativeBuildInputs ? [ ]
, propagatedBuildInputs ? [ ]
, propagatedNativeBuildInputs ? [ ]
, ...
}@attrs:
let
  mergeInputs = name:
    (attrs.${name} or [ ]) ++
    # 1. get all `{build,nativeBuild,...}Inputs` from the elements of `inputsFrom`
    # 2. since that is a list of lists, `flatten` that into a regular list
    # 3. filter out of the result everything that's in `inputsFrom` itself
    # this leaves actual dependencies of the derivations in `inputsFrom`, but never the derivations themselves
    (lib.subtractLists inputsFrom (lib.flatten (lib.catAttrs name inputsFrom)));

  rest = builtins.removeAttrs attrs [
    "name"
    "packages"
    "inputsFrom"
    "buildInputs"
    "nativeBuildInputs"
    "propagatedBuildInputs"
    "propagatedNativeBuildInputs"
    "shellHook"
  ];

  merged = {
    buildInputs = mergeInputs "buildInputs";
    nativeBuildInputs = packages ++ (mergeInputs "nativeBuildInputs");
    propagatedBuildInputs = mergeInputs "propagatedBuildInputs";
    propagatedNativeBuildInputs = mergeInputs "propagatedNativeBuildInputs";
  };

  docPathShellHook = let
    unwrapCC = pkg: if pkg ? cc then unwrapCC pkg.cc else pkg;
    docInputs = builtins.concatLists (builtins.attrValues merged)
                # grab the unwrapped cc, as wrappers may or may not
                # retain doc outputs
                ++ (lib.optional (stdenv ? cc) (unwrapCC stdenv.cc))
                ++ stdenv.defaultBuildInputs ++ stdenv.defaultNativeBuildInputs
                ++ stdenv.initialPath;
    docDrvs = lib.unique (builtins.filter lib.isDerivation docInputs);
    docPaths = type: lib.pipe docDrvs [
      (map (lib.getOutput type))
      (map (out: builtins.toPath "${out}/share/${type}"))
      (builtins.filter builtins.pathExists)
    ];
    infoPaths = docPaths "info";
    manPaths = docPaths "man";

    # some packages neglect to build an info dir file
    infoDirAddenda = stdenv.mkDerivation {
      inherit (stdenv) system;
      name = "${name}-info-dir-addenda";
      passAsFile = ["buildCommand"];
      buildCommand = ''
        shopt -s nullglob
        mkdir -p $out/share/info
        for path in ${builtins.concatStringsSep " " infoPaths}; do
          [[ -s $path/dir ]] && continue || :
          for file in $path/*.info{,.gz}; do
            ${buildPackages.texinfo}/bin/install-info $file $out/share/info/dir
          done
        done
      '';
    };
  in ''
    export INFOPATH=${builtins.concatStringsSep ":" (infoPaths ++ [(builtins.toPath "${infoDirAddenda}/share/info")])}:$INFOPATH
    export MANPATH=${builtins.concatStringsSep ":" manPaths}:$MANPATH
  '';
in

stdenv.mkDerivation ({
  inherit name;

  inherit (merged)
    buildInputs nativeBuildInputs
    propagatedBuildInputs propagatedNativeBuildInputs;

  shellHook = lib.concatStringsSep "\n" ((lib.catAttrs "shellHook"
    (lib.reverseList inputsFrom ++ [ attrs ]))
  ++ [docPathShellHook]);

  phases = [ "buildPhase" ];

  buildPhase = ''
    { echo "------------------------------------------------------------";
      echo " WARNING: the existence of this path is not guaranteed.";
      echo " It is an internal implementation detail for pkgs.mkShell.";
      echo "------------------------------------------------------------";
      echo;
      # Record all build inputs as runtime dependencies
      export;
    } >> "$out"
  '';

  preferLocalBuild = true;
} // rest)
