{stdenv, fetchgit, mono, gtksharp, pkgconfig}:

stdenv.mkDerivation {
  name = "pinta-0.3";

  src = fetchgit {
    url = http://github.com/jpobst/Pinta.git;
    rev = "0.3";
    sha256 = "17fde1187be4cfd50a9acda4ba45584e24d51ff22df5074654bed23f61faf33b";
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
    ensureDir $out/lib/pinta $out/bin
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
    license = "MIT";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
