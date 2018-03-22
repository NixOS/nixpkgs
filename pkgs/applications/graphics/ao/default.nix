{stdenv, fetchgit, cmake, ninja, boost, libpng, glfw3, epoxy, guile, pkgconfig
, libGLU_combined, libX11, libpthreadstubs, libXau, libXdmcp, libXrandr, libXext
, libXinerama, libXxf86vm, libXcursor, libXfixes
}:
stdenv.mkDerivation rec {
  version = "0.0pre20160820";
  name = "ao-${version}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake ninja boost libpng glfw3 epoxy guile libGLU_combined libX11 
    libpthreadstubs libXau libXdmcp libXrandr libXext libXinerama libXxf86vm
    libXcursor libXfixes
  ];

  src = fetchgit {
    url = https://github.com/mkeeter/ao;
    rev = "69fadb81543cc9031e4a7ec2036c7f2ab505a620";
    sha256 = "1717k72vr0i5j7bvxmd6q16fpvkljnqfa1hr3i4yq8cjdsj69my7";
  };

  cmakeFlags = "-G Ninja";
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
