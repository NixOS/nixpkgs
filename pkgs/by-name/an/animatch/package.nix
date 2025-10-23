{
  lib,
  allegro5,
  cmake,
  fetchFromGitLab,
  libGL,
  stdenv,
  xorg,
}:
stdenv.mkDerivation rec {
  pname = "animatch";
  version = "1.0.3";
  src = fetchFromGitLab {
    owner = "HolyPangolin";
    repo = "animatch";
    fetchSubmodules = true;
    tag = "v${version}";
    hash = "sha256-zBV45WMAXtCpPPbDpr04K/a9UtZ4KLP9nUauBlbhrFo=";
  };

  postPatch = ''
    substituteInPlace libsuperderpy/src/3rdparty/cimgui/CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 3.1)' \
      'cmake_minimum_required(VERSION 4.0)'
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    allegro5
    libGL
    xorg.libX11
  ];

  cmakeFlags = [
    "-DLIBSUPERDERPY_STATIC=ON" # recommended by upstream for coexistence with other superderpy games
  ];

  strictDeps = true;

  meta = {
    homepage = "https://gitlab.com/HolyPangolin/animatch/";
    description = "Cute match three game for the Librem 5 smartphone";
    mainProgram = "animatch";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ colinsane ];
  };
}
