{ stdenv
, lib
, fetchFromGitHub
, gitUpdater
, cmake
, pkg-config
, python3
, SDL2
, fontconfig
, gtk3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "openboardview";
  version = "9.0.3";

  src = fetchFromGitHub {
    owner = "OpenBoardView";
    repo = "OpenBoardView";
    rev = version;
    sha256 = "sha256-0vxWFNM9KQ5zs+VDDV3mVMfHZau4pgNxQ1HhH2vktCM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config python3 wrapGAppsHook ];
  buildInputs = [ SDL2 fontconfig gtk3 ];

  postPatch = ''
    substituteInPlace src/openboardview/CMakeLists.txt \
      --replace "SDL2::SDL2main" ""
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DGLAD_REPRODUCIBLE=On"
  ];

  dontWrapGApps = true;
  postFixup = ''
    wrapGApp "$out/bin/${pname}" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ gtk3 ]}
  '';

  passthru.updateScript = gitUpdater {
    inherit pname version;
    ignoredVersions = ''.*\.90\..*'';
  };

  meta = with lib; {
    description = "Linux SDL/ImGui edition software for viewing .brd files";
    homepage = "https://github.com/OpenBoardView/OpenBoardView";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ k3a ];
  };
}
