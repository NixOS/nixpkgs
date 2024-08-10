# Generates the documentation for library functions via nixdoc.
# To build this derivation, run `nix-build -A nixpkgs-manual.lib-docs`
{
  lib,
  stdenvNoCC,
  nixdoc,
  nix,
  nixpkgs ? { },
  libsets ? [
    {
      name = "asserts";
      description = "assertion functions";
    }
    {
      name = "attrsets";
      description = "attribute set functions";
    }
    {
      name = "strings";
      description = "string manipulation functions";
    }
    {
      name = "versions";
      description = "version string functions";
    }
    {
      name = "trivial";
      description = "miscellaneous functions";
    }
    {
      name = "fixedPoints";
      baseName = "fixed-points";
      description = "explicit recursion functions";
    }
    {
      name = "lists";
      description = "list manipulation functions";
    }
    {
      name = "debug";
      description = "debugging functions";
    }
    {
      name = "options";
      description = "NixOS / nixpkgs option handling";
    }
    {
      name = "path";
      description = "path functions";
    }
    {
      name = "filesystem";
      description = "filesystem functions";
    }
    {
      name = "fileset";
      description = "file set functions";
    }
    {
      name = "sources";
      description = "source filtering functions";
    }
    {
      name = "cli";
      description = "command-line serialization functions";
    }
    {
      name = "generators";
      description = "functions that create file formats from nix data structures";
    }
    {
      name = "gvariant";
      description = "GVariant formatted string serialization functions";
    }
    {
      name = "customisation";
      description = "Functions to customise (derivation-related) functions, derivatons, or attribute sets";
    }
    {
      name = "meta";
      description = "functions for derivation metadata";
    }
    {
      name = "derivations";
      description = "miscellaneous derivation-specific functions";
    }
  ],
}:

stdenvNoCC.mkDerivation {
  name = "nixpkgs-lib-docs";

  src = lib.fileset.toSource {
    root = ../..;
    fileset = ../../lib;
  };

  buildInputs = [
    nixdoc
    nix
  ];

  installPhase = ''
    export NIX_STATE_DIR=$(mktemp -d)
    nix-instantiate --eval --strict --json ${./lib-function-locations.nix} \
      --arg nixpkgsPath "./." \
      --argstr revision ${nixpkgs.rev or "master"} \
      --argstr libsetsJSON ${lib.escapeShellArg (builtins.toJSON libsets)} \
      > locations.json

    function docgen {
      name=$1
      baseName=$2
      description=$3
      # TODO: wrap lib.$name in <literal>, make nixdoc not escape it
      if [[ -e "lib/$baseName.nix" ]]; then
        nixdoc -c "$name" -d "lib.$name: $description" -l locations.json -f "lib/$baseName.nix" > "$out/$name.md"
      else
        nixdoc -c "$name" -d "lib.$name: $description" -l locations.json -f "lib/$baseName/default.nix" > "$out/$name.md"
      fi
      echo "$out/$name.md" >> "$out/index.md"
    }

    mkdir -p "$out"

    cat > "$out/index.md" << 'EOF'
    ```{=include=} sections auto-id-prefix=auto-generated
    EOF

    ${lib.concatMapStrings (
      {
        name,
        baseName ? name,
        description,
      }:
      ''
        docgen ${name} ${baseName} ${lib.escapeShellArg description}
      ''
    ) libsets}

    echo '```' >> "$out/index.md"
  '';
}
