{
  lib,
  stdenv,
  runtimeShell,
}:

stdenv.mkDerivation {
  pname = "example-unfree-package";
  version = "1.0";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/hello-unfree << EOF
    #!${runtimeShell}
    echo "Hello, you are running an unfree system!"
    EOF
    chmod +x $out/bin/hello-unfree
  '';

  meta = with lib; {
    description = "Example package with unfree license (for testing)";
    license = licenses.unfree;
    maintainers = [ maintainers.oxij ];
    mainProgram = "hello-unfree";
  };
}
