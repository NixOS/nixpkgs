# Generates the documentation for library functions via nixdoc.

{ pkgs, nixpkgs, libsets }:

with pkgs;

let
  locationsJSON = import ./lib-function-locations.nix { inherit pkgs nixpkgs libsets; };
in
stdenv.mkDerivation {
  name = "nixpkgs-lib-docs";
  src = ../../lib;

  buildInputs = [ nixdoc ];
  installPhase = ''
    function docgen {
      # TODO: wrap lib.$1 in <literal>, make nixdoc not escape it
      if [[ -e "../lib/$1.nix" ]]; then
        nixdoc -c "$1" -d "lib.$1: $2" -l ${locationsJSON} -f "$1.nix" > "$out/$1.md"
      else
        nixdoc -c "$1" -d "lib.$1: $2" -l ${locationsJSON} -f "$1/default.nix" > "$out/$1.md"
      fi
      echo "$out/$1.md" >> "$out/index.md"
    }

    mkdir -p "$out"

    cat > "$out/index.md" << 'EOF'
    ```{=include=} sections
    EOF

    ${lib.concatMapStrings ({ name, description }: ''
      docgen ${name} ${lib.escapeShellArg description}
    '') libsets}

    echo '```' >> "$out/index.md"
  '';
}
