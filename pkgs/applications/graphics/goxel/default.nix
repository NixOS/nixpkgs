{ stdenv, fetchFromGitHub, scons, pkgconfig, wrapGAppsHook
, glfw3, gtk3, libpng12 }:

stdenv.mkDerivation rec {
  name = "goxel-${version}";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "guillaumechereau";
    repo = "goxel";
    rev = "v${version}";
    sha256 = "14rycn6sd3wp90c9ghpif1al3rv1fdgvhmpldmwap0pk790kfxs1";
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
    platforms = [ "x86_64-linux" ]; # see https://github.com/guillaumechereau/goxel/issues/125
    maintainers = with maintainers; [ tilpner ];
  };
}
