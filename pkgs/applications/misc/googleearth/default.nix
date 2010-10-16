{ stdenv, fetchurl, glibc, mesa, freetype, glib, libSM, libICE, libXi, libXv,
libXrender, libXrandr, libXfixes, libXcursor, libXinerama, libXext, libX11, qt4,
zlib }:

/* I haven't found any x86_64 package from them */
assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "googleearth-5.2.0001";

  src = fetchurl {
    url = http://dl.google.com/earth/client/current/GoogleEarthLinux.bin;
    sha256 = "2e6fcbd2384446e2a6eed8ca23173e32c5f3f9ae4d1168e2e348c3924fd2bf30";
  };

  buildNativeInputs = [
    glibc
    glib
    stdenv.gcc.gcc
    libSM 
    libICE 
    libXi 
    libXv
    mesa
    libXrender 
    libXrandr 
    libXfixes 
    libXcursor 
    libXinerama 
    freetype 
    libXext 
    libX11 
    qt4
    zlib
  ];

  phases = "unpackPhase installPhase";
  
  unpackPhase = ''
    bash $src --noexec --target unpacked
    cd unpacked
  '';
  
  installPhase =''
    ensureDir $out/{opt/googleearth/,bin};
    tar xf googleearth-data.tar -C $out/opt/googleearth
    tar xf googleearth-linux-x86.tar -C $out/opt/googleearth
    cp bin/googleearth $out/opt/googleearth
    cat > $out/bin/googleearth << EOF
    #!/bin/sh
    export GOOGLEEARTH_DATA_PATH=$out/opt/googleearth
    exec $out/opt/googleearth/googleearth
    EOF
    chmod +x $out/bin/googleearth

    fullPath=
    for i in $buildNativeInputs; do
      fullPath=$fullPath:$i/lib
    done
          
    patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath $fullPath \
      $out/opt/googleearth/googleearth-bin

    for a in $out/opt/googleearth/*.so* ; do
      patchelf --set-rpath $fullPath $a
    done
  '';

  meta = {
    description = "A world sphere viewer";
    homepage = http://earth.google.com;
    license = "unfree";
    maintainers = [ stdenv.lib.maintainers.viric ];
  };
}
