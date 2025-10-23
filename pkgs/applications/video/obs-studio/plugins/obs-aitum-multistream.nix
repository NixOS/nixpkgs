{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  obs-studio,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "obs-aitum-multistream";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "Aitum";
    repo = "obs-aitum-multistream";
    tag = version;
    hash = "sha256-TqddyTBRWLyfwYi9I0nQE8Z19YL2RwkZqUwi7F9XpwQ=";
  };

  # Remove after https://github.com/Aitum/obs-aitum-multistream/pull/15 is released :)
  patches = [ ./obs-aitum-multistream.diff ];

  # Fix FTBFS with Qt >= 6.8
  prePatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'find_qt(COMPONENTS Widgets Core)' 'find_package(Qt6 REQUIRED COMPONENTS Core Widgets)'
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    curl
    obs-studio
    qtbase
  ];
  dontWrapQtApps = true;

  cmakeFlags = [
    # Prevent deprecation warnings from failing the build
    (lib.cmakeOptionType "string" "CMAKE_CXX_FLAGS" "-Wno-error=deprecated-declarations")
  ];

  meta = {
    description = "Plugin to stream everywhere from a single instance of OBS";
    homepage = "https://github.com/Aitum/obs-aitum-multistream";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}
