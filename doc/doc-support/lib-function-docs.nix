# Generates the documentation for library functions via nixdoc.

{ pkgs, locationsXml, libsets }:

with pkgs; stdenv.mkDerivation {
  name = "nixpkgs-lib-docs";
  src = ../../lib;

  buildInputs = [ nixdoc ];
  installPhase = ''
    function docgen {
      # TODO: wrap lib.$1 in <literal>, make nixdoc not escape it
      if [[ -e "../lib/$1.nix" ]]; then
        nixdoc -c "$1" -d "lib.$1: $2" -f "$1.nix" > "$out/$1.xml"
      else
        nixdoc -c "$1" -d "lib.$1: $2" -f "$1/default.nix" > "$out/$1.xml"
      fi
      echo "<xi:include href='$1.xml' />" >> "$out/index.xml"
    }

    mkdir -p "$out"

    cat > "$out/index.xml" << 'EOF'
    <?xml version="1.0" encoding="utf-8"?>
    <root xmlns:xi="http://www.w3.org/2001/XInclude">
    EOF

    ${lib.concatMapStrings ({ name, description }: ''
      docgen ${name} ${lib.escapeShellArg description}
    '') libsets}

    echo "</root>" >> "$out/index.xml"

    ln -s ${locationsXml} $out/locations.xml
  '';
}
