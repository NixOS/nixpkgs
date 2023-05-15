{ lib
, stdenv
, fetchFromGitHub
, cmake
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-3d-effect";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-3d-effect";
    rev = version;
    sha256 = "sha256-1frLQo+0/HxTIkZ57rnQjVOos5+bv2cLojslSCGo+gU=";
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
    description = "Plugin for OBS Studio adding 3D effect filter";
    homepage = "https://github.com/exeldro/obs-3d-effect";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
