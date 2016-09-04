{stdenv, fetchgit, cmake, ninja, boost, libpng, glfw3, epoxy, guile, pkgconfig
, mesa, libX11, libpthreadstubs, libXau, libXdmcp, libXrandr, libXext
, libXinerama, libXxf86vm, libXcursor, libXfixes
}:
stdenv.mkDerivation rec {
  version = "0.0pre20160820";
  name = "ao-${version}";
  buildInputs = [
    cmake ninja boost libpng glfw3 epoxy guile pkgconfig mesa libX11 
    libpthreadstubs libXau libXdmcp libXrandr libXext libXinerama libXxf86vm
    libXcursor libXfixes
    ];
  src = fetchgit (stdenv.lib.importJSON ./src.json);
  cmakeFlags = "-G Ninja";
  buildPhase = "ninja";
  installPhase = ''
    ninja install
    cd ..
    cp lib/lib* bind/lib* "$out/lib"
    cp -r bin "$out/bin"
    mkdir "$out/doc"
    cp -r doc "$out/doc/ao"
    cp -r examples "$out/doc/ao/examples"
    cp -r bind "$out/bind"
  '';
  meta = {
    inherit version;
    description = ''Homoiconic CAD package'';
    license = stdenv.lib.licenses.gpl2Plus ; # Some parts can be extracted and used under LGPL2+
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
