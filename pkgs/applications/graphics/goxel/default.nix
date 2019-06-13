{ stdenv, fetchFromGitHub, scons, pkgconfig, wrapGAppsHook
, glfw3, gtk3, libpng12 }:

stdenv.mkDerivation rec {
  name = "goxel-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "guillaumechereau";
    repo = "goxel";
    rev = "v${version}";
    sha256 = "1vd1vw5pplm4ig9f5gwnbvndnag1h7j0jj0cnj78gpiv96qak2vw";
  };

  patches = [ ./disable-imgui_ini.patch ];

  nativeBuildInputs = [ scons pkgconfig wrapGAppsHook ];
  buildInputs = [ glfw3 gtk3 libpng12 ];
  NIX_LDFLAGS = [
    "-lpthread"
  ];

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
