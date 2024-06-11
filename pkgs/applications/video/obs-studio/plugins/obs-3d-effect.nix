{ lib
, stdenv
, fetchFromGitHub
, cmake
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-3d-effect";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-3d-effect";
    rev = version;
    sha256 = "sha256-CAWx1wgk6G+9O7PkplrTg7uCmb8Yt6U3Z6YMVsq7IrQ=";
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
