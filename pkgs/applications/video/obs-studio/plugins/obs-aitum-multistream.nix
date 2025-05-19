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
    rev = version;
    sha256 = "sha256-TqddyTBRWLyfwYi9I0nQE8Z19YL2RwkZqUwi7F9XpwQ=";
  };

  # Fix FTBFS with Qt >= 6.8
  prePatch = ''
    sed -i 's/find_qt(COMPONENTS Widgets Core)/find_package(Qt6 REQUIRED COMPONENTS Core Widgets)/' CMakeLists.txt
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

  meta = with lib; {
    description = "Plugin to stream everywhere from a single instance of OBS";
    homepage = "https://github.com/Aitum/obs-aitum-multistream";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
