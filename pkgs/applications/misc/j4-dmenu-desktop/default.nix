{ lib, stdenv, fetchFromGitHub, cmake, dmenu, fmt, spdlog }:

stdenv.mkDerivation rec {
  pname = "j4-dmenu-desktop";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "enkore";
    repo = "j4-dmenu-desktop";
    rev = "r${version}";
    hash = "sha256-/HlH7BIQvsczzXm8SFwSRKlt5kj38l3DYFJ655J1qas=";
  };

  postPatch = ''
    substituteInPlace src/main.cc \
        --replace "dmenu -i" "${lib.getExe dmenu} -i"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    fmt
    spdlog
  ];

  # Disable unit tests and the fetching of external dependencies.
  cmakeFlags = [
    "-DWITH_TESTS=OFF"
    "-DNO_DOWNLOAD=ON"
  ];

  meta = with lib; {
    changelog = "https://github.com/enkore/j4-dmenu-desktop/blob/${version}/CHANGELOG";
    description = "Wrapper for dmenu that recognizes .desktop files";
    homepage = "https://github.com/enkore/j4-dmenu-desktop";
    license = licenses.gpl3Only;
    mainProgram = "j4-dmenu-desktop";
    maintainers = with maintainers; [ ericsagnes ];
    platforms = platforms.unix;
  };
}
