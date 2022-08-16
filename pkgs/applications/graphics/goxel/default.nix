{ lib, stdenv, fetchFromGitHub, scons, pkg-config, wrapGAppsHook
, glfw3, gtk3, libpng12 }:

stdenv.mkDerivation rec {
  pname = "goxel";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "guillaumechereau";
    repo = "goxel";
    rev = "v${version}";
    sha256 = "sha256-FrPoKJXzWzfUF0ITYxIUdHi0kCh2VJ+A093HaXxMofA=";
  };

  patches = [ ./disable-imgui_ini.patch ];

  nativeBuildInputs = [ scons pkg-config wrapGAppsHook ];
  buildInputs = [ glfw3 gtk3 libpng12 ];

  buildPhase = ''
    make release
  '';

  installPhase = ''
    install -D ./goxel $out/bin/goxel
  '';

  meta = with lib; {
    description = "Open Source 3D voxel editor";
    homepage = "https://guillaumechereau.github.io/goxel/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tilpner ];
  };
}
