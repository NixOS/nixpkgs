{ lib
, stdenv
, fetchFromGitHub
, cmake
, obs-studio
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "obs-transition-table";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-transition-table";
    rev = version;
    sha256 = "sha256-Is2XWMPhqd/rd6cXc40eSZTvSRpbroTBzM4SPfHOWPg=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio qtbase ];

  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
  ];

  dontWrapQtApps = true;

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = with lib; {
    description = "Plugin for OBS Studio to add a Transition Table to the tools menu.";
    homepage = "https://github.com/exeldro/obs-transition-table";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
