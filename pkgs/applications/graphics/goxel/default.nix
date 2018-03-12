{ stdenv, lib, fetchFromGitHub, scons, pkgconfig, wrapGAppsHook
, glfw3, gtk3, libpng12 }:

stdenv.mkDerivation rec {
  name = "goxel-${version}";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "guillaumechereau";
    repo = "goxel";
    rev = "v${version}";
    sha256 = "1d6waj8zz9iq3ddbi9wbpcnh200ajjy9x53xrj5bij01pb8jwskv";
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
