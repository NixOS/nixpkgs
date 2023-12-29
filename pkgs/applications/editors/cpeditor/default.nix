{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, qtbase
, qttools
, wrapQtAppsHook
, cmake
, ninja
, python3
, runtimeShell
}:

stdenv.mkDerivation rec {
  pname = "cpeditor";
  version = "6.11.1";

  src = fetchFromGitHub {
    owner = "cpeditor";
    repo = "cpeditor";
    rev = version;
    sha256 = "sha256-Uwo7ZE+9yrHV/+D6rvfew2d3ZJbpFOjgek38iYkPppw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ninja pkg-config wrapQtAppsHook python3 ];
  buildInputs = [ qtbase qttools ];

  postPatch = ''
    substituteInPlace src/Core/Runner.cpp --replace "/bin/bash" "${runtimeShell}"
  '';

  env.NIX_CFLAGS_COMPILE = "-std=c++14";

  meta = with lib; {
    description = "An IDE specially designed for competitive programming";
    homepage = "https://cpeditor.org";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
    mainProgram = "cpeditor";
  };
}
