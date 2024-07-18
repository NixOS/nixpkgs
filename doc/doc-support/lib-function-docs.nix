# Generates the documentation for library functions via nixdoc.

{ pkgs, nixpkgs, libsets }:

with pkgs;

stdenv.mkDerivation {
  name = "nixpkgs-lib-docs";
  src = pkgs.lib.fileset.toSource {
    root = ../..;
    fileset = ../../lib;
  };

  buildInputs = [ nixdoc nix ];
  installPhase = ''
    export NIX_STATE_DIR=$(mktemp -d)
    nix-instantiate --eval --strict --json ${./lib-function-locations.nix} \
      --arg nixpkgsPath "./." \
      --argstr revision ${nixpkgs.rev or "master"} \
      --argstr libsetsJSON ${pkgs.lib.escapeShellArg (builtins.toJSON libsets)} \
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

    ${lib.concatMapStrings ({ name, baseName ? name, description }: ''
      docgen ${name} ${baseName} ${lib.escapeShellArg description}
    '') libsets}

    echo '```' >> "$out/index.md"
  '';
}
