{ stdenv, fetchgit, cmake, pkgconfig, zlib, libpng, cairo, freetype
, json_c, fontconfig, gtkmm3, pangomm, glew, libGLU, xorg, pcre
, wrapGAppsHook
}:
stdenv.mkDerivation rec {
  name = "solvespace-2.3-20190422";
  rev = "fa6622903010eb82b07b16adf06d31d5ffcd6bb9";

  src = fetchgit {
    url = https://github.com/solvespace/solvespace;
    inherit rev;
    sha256 = "144w5l8cc5cpzqm6hjdp98a5k08whska1hmvwnz0c7glfji4z4dk";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkgconfig cmake wrapGAppsHook
  ];
  buildInputs = [
    zlib libpng cairo freetype
    json_c fontconfig gtkmm3 pangomm glew libGLU
    xorg.libpthreadstubs xorg.libXdmcp pcre
  ];
  enableParallelBuilding = true;

  postInstall = ''
    substituteInPlace $out/share/applications/solvespace.desktop \
      --replace /usr/bin/ $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A parametric 3d CAD program";
    license = licenses.gpl3;
    maintainers = [ maintainers.edef ];
    platforms = platforms.linux;
    homepage = http://solvespace.com;
  };
}
