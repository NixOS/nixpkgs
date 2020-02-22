{ stdenv, fetchFromGitHub, scons, pkgconfig, wrapGAppsHook
, glfw3, gtk3, libpng12 }:

stdenv.mkDerivation rec {
  pname = "goxel";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "guillaumechereau";
    repo = "goxel";
    rev = "v${version}";
    sha256 = "1b63jqryq19qa81g1ml6d85f27wj1ci3h56r02cl9xn8di5p674f";
  };

  patches = [ ./disable-imgui_ini.patch ];

  nativeBuildInputs = [ scons pkgconfig wrapGAppsHook ];
  buildInputs = [ glfw3 gtk3 libpng12 ];
  NIX_LDFLAGS = "-lpthread";

  buildPhase = ''
    make release
  '';

  installPhase = ''
    install -D ./goxel $out/bin/goxel
  '';

  meta = with stdenv.lib; {
    description = "Open Source 3D voxel editor";
    homepage = https://guillaumechereau.github.io/goxel/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tilpner ];
  };
}
