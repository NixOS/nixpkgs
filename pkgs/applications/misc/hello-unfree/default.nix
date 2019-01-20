{ stdenv }:

stdenv.mkDerivation rec {
  name = "example-unfree-package-${version}";
  version = "1.0";

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/hello-unfree << EOF
    #!${stdenv.shell}
    echo "Hello, you are running an unfree system!"
    EOF
    chmod +x $out/bin/hello-unfree
  '';

  meta = {
    description = "An example package with unfree license (for testing)";
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.oxij ];
  };
}
