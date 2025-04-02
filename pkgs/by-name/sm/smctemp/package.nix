{
  lib,
  stdenv,
  fetchFromGitHub,
  darwin,
}:

stdenv.mkDerivation rec {
  pname = "smctemp";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "narugit";
    repo = pname;
    rev = version;
    hash = "sha256-opkE4XYe2x+4TwZ7AZ001NDJ0eC4JXcHwMKzkQA1E0w=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.IOKit
  ];

  patchPhase = ''
    substituteInPlace Makefile \
      --replace 'CXX := g++' 'CXX := c++' \
      --replace 'CXXFLAGS := -Wall -std=c++17 -g -framework IOKit' \
                'CXXFLAGS := -Wall -std=c++17 -g -framework IOKit -Wno-deprecated-declarations -Wno-format-security' \
      --replace 'DEST_PREFIX := /usr/local' 'DEST_PREFIX := $(PREFIX)' \
      --replace 'PROCESS_IS_TRANSLATED := $(shell sysctl -in sysctl.proc_translated)' \
                'PROCESS_IS_TRANSLATED := 0'
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "CLI tool to print CPU and GPU temperature on macOS";
    homepage = "https://github.com/narugit/smctemp";
    license = licenses.gpl2;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ ivankovnatsky ];
    mainProgram = "smctemp";
  };
}
