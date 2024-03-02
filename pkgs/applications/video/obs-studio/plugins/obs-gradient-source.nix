{ lib
, stdenv
, fetchFromGitHub
, cmake
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "obs-gradient-source";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-gradient-source";
    rev = version;
    sha256 = "sha256-5pll84UZYOTESrid2UuC1aWlaLrWf1LpXqlV09XKLug=";
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
