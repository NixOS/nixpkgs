# Generates the documentation for library functions via nixdoc.

{ pkgs, nixpkgs, libsets, library, src, name }:

with pkgs;

let
  locationsJSON = import ./lib-function-locations.nix { inherit pkgs nixpkgs libsets library; };
in
stdenv.mkDerivation {
  inherit src name;

  buildInputs = [ nixdoc ];
  installPhase = ''
    function docgen {
      name=$1
      baseName=$2
      description=$3
      # TODO: wrap lib.$name in <literal>, make nixdoc not escape it
      if [[ -e "../lib/$baseName.nix" ]]; then
        nixdoc -c "$name" -d "lib.$name: $description" -l ${locationsJSON} -f "$baseName.nix" > "$out/$name.md"
      else
        nixdoc -c "$name" -d "lib.$name: $description" -l ${locationsJSON} -f "$baseName/default.nix" > "$out/$name.md"
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
