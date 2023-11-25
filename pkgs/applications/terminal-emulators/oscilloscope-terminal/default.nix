{ lib
, stdenv
, fetchFromGitHub
, cmake
, SDL2
, bash
, shell ? bash # dunno how to override this...
, WIDTH ? 80
, HEIGHT ? 24
, BLOCK_SIZE ? 2048
, BLOCKSFRAME ? 4
, SAMP_RATE ? 192000
}:

stdenv.mkDerivation rec {
  pname = "oscilloscope-terminal";
  version = "unstable-2023-05-12";

  src = fetchFromGitHub {
    owner = "arf20";
    repo = "oscilloscope-terminal";
    rev = "dad28ec3c4e8c75d1400f387370491f4c868dda9";
    hash = "sha256-fjM1g6YM6+Sen4/rzNXduuDDVD2eSV+UdDPzJUvW0SY=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ SDL2 ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "target_link_libraries(oscilloscope-terminal Threads::Threads SDL2main SDL2 GL)" \
                "target_link_libraries(oscilloscope-terminal Threads::Threads SDL2 GL)"

    substituteInPlace terminal.cpp --replace "/bin/bash" "${shell}${shell.shellPath}"

    substituteInPlace main.hpp --replace "WIDTH   80" "WIDTH   ${toString WIDTH}"
    substituteInPlace main.hpp --replace "HEIGHT  24" "HEIGHT  ${toString HEIGHT}"
    substituteInPlace main.hpp --replace "BLOCKSFRAME 4" "BLOCKSFRAME ${toString BLOCKSFRAME}"
    substituteInPlace main.hpp --replace "BLOCK_SIZE  2048" "BLOCK_SIZE  ${toString BLOCK_SIZE}"
    substituteInPlace main.hpp --replace "SAMP_RATE   192000" "SAMP_RATE   ${toString SAMP_RATE}"
  '';

  meta = with lib; {
    description = "Turns your oscilloscope (+sound card) into a Linux terminal emulator";
    homepage = "https://github.com/arf20/oscilloscope-terminal";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ evils ];
  };
}
