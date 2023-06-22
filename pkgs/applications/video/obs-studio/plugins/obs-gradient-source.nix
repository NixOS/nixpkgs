{ lib
, stdenv
, fetchFromGitHub
, cmake
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-gradient-source";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-gradient-source";
    rev = version;
    sha256 = "sha256-4u7RzF2b7EWwsfEtRvGDifue34jJM4MaYpwumu0MFpQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
  ];

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = with lib; {
    description = "Plugin for adding a gradient Source to OBS Studio";
    homepage = "https://github.com/exeldro/obs-gradient-source";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
