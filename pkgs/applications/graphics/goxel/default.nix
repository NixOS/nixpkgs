{ stdenv, lib, fetchFromGitHub, scons, pkgconfig, wrapGAppsHook
, glfw3, gtk3, libpng12 }:

stdenv.mkDerivation rec {
  name = "goxel-${version}";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "guillaumechereau";
    repo = "goxel";
    rev = "v${version}";
    sha256 = "114s1pbv3ixc2gzkg7n927hffd6ly5gg59izw4z6drgjcdhd7xj9";
  };

  nativeBuildInputs = [ scons pkgconfig wrapGAppsHook ];
  buildInputs = [ glfw3 gtk3 libpng12 ];

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
