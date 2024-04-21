# Generates the documentation for library functions via nixdoc.

{ pkgs, nixpkgs, libsets, library, src, name, prefix }:

with pkgs;

let
  locationsJSON = import ./lib-function-locations.nix { inherit pkgs nixpkgs libsets library prefix; };
in
stdenv.mkDerivation {
  inherit src name;

  buildInputs = [ nixdoc ];
  env = {
    # lower case $prefix is written by setup.sh for ./configure when empty
    PREFIX = prefix;
    PREFIXDOT = if prefix == "" then "" else "${prefix}.";
  };
  installPhase = ''
    function docgen {
      name=$1
      baseName=$2
      description=$3
      # TODO: wrap ${prefix}$name in <literal>, make nixdoc not escape it
      if [[ -e "../lib/$baseName.nix" ]]; then
        nixdoc -c "$name" -d "$PREFIXDOT$name: $description" -l ${locationsJSON} -f "$baseName.nix" --prefix "$PREFIX" > "$out/$name.md"
      else
        nixdoc -c "$name" -d "$PREFIXDOT$name: $description" -l ${locationsJSON} -f "$baseName/default.nix" --prefix "$PREFIX" > "$out/$name.md"
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
