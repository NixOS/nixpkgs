# We don't have a wrapper which can supply obs-studio plugins so you have to
# somewhat manually install this:

# nix-env -f "<nixpkgs>" -iA obs-ndi
# mkdir -p ~/.config/obs-studio/plugins
# ln -s ~/.nix-profile/share/obs/obs-plugins/obs-ndi ~/.config/obs-studio/plugins/

{ stdenv, fetchFromGitHub, obs-studio, cmake, qt5 }:

stdenv.mkDerivation rec {
  pname = "obs-ndi";
  version = "4.7.1";

  src = fetchFromGitHub {
    owner = "Palakis";
    repo = "obs-ndi";
    rev = version;
    sha256 = "040fkbf3f3qgqcrd3072y3zrjb4fwga8zr10jym744xd7bgyylqh";
  };

  patches = [ ./fix-search-path.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio qt5.qtbase ];

  cmakeFlags = [
    "-DLIBOBS_INCLUDE_DIR=${obs-studio}/include/obs"
    "-DLIBOBS_LIB=${obs-studio}/lib"
    "-DCMAKE_CXX_FLAGS=-I${obs-studio.src}/UI/obs-frontend-api"
  ];

  meta = with stdenv.lib; {
    description = "Network A/V plugin for OBS Studio";
    homepage = https://github.com/Palakis/obs-ndi;
    maintainers = with maintainers; [ peti ];
    license = licenses.gpl2;
    platforms = with platforms; linux;
  };
}
