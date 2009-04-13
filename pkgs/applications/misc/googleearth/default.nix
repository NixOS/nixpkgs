{ stdenv, fetchurl, glibc, mesa, freetype, glib, libSM, libICE, libXi, libXv,
libXrender, libXrandr, libXfixes, libXcursor, libXinerama, libXext, libX11 }:

stdenv.mkDerivation {
  name = "googleearth-5.11337.1968";

/*
  src = fetchurl {
    url = http://dl.google.com/earth/client/ge4/release_4_3/googleearth-linux-plus-4.3.7284.3916.bin;
    sha256 = "0zi7d1708ni6vgm2vy9q0y8w7dxl8qinnpplkrlb7x0x3671rdxf";
  };
*/
  src = fetchurl {
    url = http://dl.google.com/earth/client/current/GoogleEarthLinux.bin;
    sha256 = "1h090rbdkp3pa97xkkjzj71k343ic8dlngj2cihw5cd1hh3f9idc";
  };

  buildInputs = [
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
    rm $out/opt/googleearth/libstdc+*
    rm $out/opt/googleearth/libgcc*
    cp bin/googleearth $out/opt/googleearth
    cat > $out/bin/googleearth << EOF
    #!/bin/sh
    export GOOGLEEARTH_DATA_PATH=$out/opt/googleearth
    exec $out/opt/googleearth/googleearth
    EOF
    chmod +x $out/bin/googleearth

    fullPath=
    for i in $buildInputs; do
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
      license = "Google";
  };
}
