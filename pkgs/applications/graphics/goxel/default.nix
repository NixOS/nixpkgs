{ lib, stdenv, fetchFromGitHub, scons, pkg-config, wrapGAppsHook
, glfw3, gtk3, libpng12 }:

stdenv.mkDerivation rec {
  pname = "goxel";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "guillaumechereau";
    repo = "goxel";
    rev = "v${version}";
    sha256 = "1v6m6nhl1if8ik5bmblhq46bip6y2qz18a04s8a9awb4yh9ls039";
  };

  patches = [ ./disable-imgui_ini.patch ];

  nativeBuildInputs = [ scons pkg-config wrapGAppsHook ];
  buildInputs = [ glfw3 gtk3 libpng12 ];
  NIX_LDFLAGS = "-lpthread";

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
