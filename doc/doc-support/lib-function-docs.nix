# Generates the documentation for library functions via nixdoc.

<<<<<<< HEAD
{ pkgs, nixpkgs, libsets }:

with pkgs;

let
  locationsJSON = import ./lib-function-locations.nix { inherit pkgs nixpkgs libsets; };
in
stdenv.mkDerivation {
=======
{ pkgs, locationsXml, libsets }:

with pkgs; stdenv.mkDerivation {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  name = "nixpkgs-lib-docs";
  src = ../../lib;

  buildInputs = [ nixdoc ];
  installPhase = ''
    function docgen {
<<<<<<< HEAD
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
=======
      # TODO: wrap lib.$1 in <literal>, make nixdoc not escape it
      if [[ -e "../lib/$1.nix" ]]; then
        nixdoc -c "$1" -d "lib.$1: $2" -f "$1.nix" > "$out/$1.xml"
      else
        nixdoc -c "$1" -d "lib.$1: $2" -f "$1/default.nix" > "$out/$1.xml"
      fi
      echo "<xi:include href='$1.xml' />" >> "$out/index.xml"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    }

    mkdir -p "$out"

<<<<<<< HEAD
    cat > "$out/index.md" << 'EOF'
    ```{=include=} sections
    EOF

    ${lib.concatMapStrings ({ name, baseName ? name, description }: ''
      docgen ${name} ${baseName} ${lib.escapeShellArg description}
    '') libsets}

    echo '```' >> "$out/index.md"
=======
    cat > "$out/index.xml" << 'EOF'
    <?xml version="1.0" encoding="utf-8"?>
    <root xmlns:xi="http://www.w3.org/2001/XInclude">
    EOF

    ${lib.concatMapStrings ({ name, description }: ''
      docgen ${name} ${lib.escapeShellArg description}
    '') libsets}

    echo "</root>" >> "$out/index.xml"

    ln -s ${locationsXml} $out/locations.xml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';
}
