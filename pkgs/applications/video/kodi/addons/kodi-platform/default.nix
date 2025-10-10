{
  stdenv,
  fetchFromGitHub,
  cmake,
  kodi,
  libcec_platform,
  tinyxml,
}:
stdenv.mkDerivation rec {
  pname = "kodi-platform";
  version = "20250416";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "kodi-platform";
    rev = "kodiplatform-${version}";
    sha256 = "sha256-W9V6O+YmH2U7xyEvWgS30sHBlIqGaaIt9jKgJ4ePNbY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    kodi
    libcec_platform
    tinyxml
  ];
}
