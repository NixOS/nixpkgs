{stdenv, fetchurl, mono, gtksharp, pkgconfig}:

stdenv.mkDerivation {
  name = "pinta-1.4";

  src = fetchurl {
    url = "https://github.com/PintaProject/Pinta/tarball/3f7ccfa93d";
    name = "pinta-1.4.tar.gz";
    sha256 = "1kgb4gy5l6bd0akniwhiqqkvqayr5jgdsvn2pgg1038q9raafnpn";
  };

  buildInputs = [mono gtksharp pkgconfig];

  buildPhase = ''
    # xbuild understands pkgconfig, but gtksharp does not give .pc for gdk-sharp
    # So we have to go the GAC-way
    export MONO_GAC_PREFIX=${gtksharp}
    xbuild Pinta.sln
  '';

  # Very ugly - I don't know enough Mono to improve this. Isn't there any rpath in binaries?
  installPhase = ''
    mkdir -p $out/lib/pinta $out/bin
    cp bin/*.{dll,exe} $out/lib/pinta
    cat > $out/bin/pinta << EOF
    #!/bin/sh
    export MONO_GAC_PREFIX=${gtksharp}:\$MONO_GAC_PREFIX
    export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${gtksharp}/lib:${gtksharp.gtk}/lib:${mono}/lib
    exec ${mono}/bin/mono $out/lib/pinta/Pinta.exe
    EOF
    chmod +x $out/bin/pinta
  '';

  # Always needed on Mono, otherwise nothing runs
  dontStrip = true; 

  meta = {
    homepage = http://www.pinta-project.com/;
    description = "Drawing/editing program modeled after Paint.NET";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
