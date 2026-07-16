# Generates the documentation for library functions via nixdoc.
# To build this derivation, run `nix-build -A nixpkgs-manual.lib-docs`
{
  stdenvNoCC,
  nixdoc,
}:
stdenvNoCC.mkDerivation {
  name = "nixpkgs-lib-docs";

  src = ../../lib;

  nativeBuildInputs = [ nixdoc ];

  buildPhase = ''
    mkdir -p src
    cp -r ${../../lib} src/lib

    mkdir -p $out
    nixdoc --manifest ${../catalog.json} --root src --output $out/lib-functions.json
  '';

  installPhase = ''
    runHook preInstall

    runHook postInstall
  '';
}
