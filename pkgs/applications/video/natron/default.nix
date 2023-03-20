{ lib
, stdenv
, fetchFromGitHub
, qt5
, cmake
, pkg-config
, boost
, cairo
, ceres-solver
, expat
, extra-cmake-modules
, glog
, libXdmcp
, python3
, python3Packages
, wayland
}:

let
  minorVersion = "2.5";
  version = "${minorVersion}.0";
  OpenColorIO-Configs = fetchFromGitHub {
    owner = "NatronGitHub";
    repo = "OpenColorIO-Configs";
    rev = "Natron-v${minorVersion}";
    sha256 = "sha256-TD7Uge9kKbFxOmOCn+TSQovnKTmFS3uERTu5lmZFHbc=";
  };
in
qt5.mkDerivation {
  inherit version;
  pname = "natron";

  src = fetchFromGitHub {
    owner = "NatronGitHub";
    repo = "Natron";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-dgScbfyulZPlrngqSw7xwipldoRd8uFO8VP9mlJyhQ8=";
  };

  cmakeFlags = [ "-DNATRON_SYSTEM_LIBS=ON" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    expat
    cairo
    python3
    python3Packages.pyside2
    python3Packages.shiboken2
    extra-cmake-modules
    wayland
    glog
    ceres-solver
    libXdmcp
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -r ${OpenColorIO-Configs} $out/share/OpenColorIO-Configs
  '';

  postFixup = ''
    wrapProgram $out/bin/Natron \
      --prefix PYTHONPATH : "${python3Packages.makePythonPath [ python3Packages.qtpy python3Packages.pyside2 ]}" \
      --set-default OCIO "$out/share/OpenColorIO-Configs/blender/config.ocio"
  '';

  meta = with lib; {
    description = "Node-graph based, open-source compositing software";
    longDescription = ''
      Node-graph based, open-source compositing software. Similar in
      functionalities to Adobe After Effects and Nuke by The Foundry.
    '';
    homepage = "https://natron.fr/";
    license = lib.licenses.gpl2;
    maintainers = [ maintainers.puffnfresh ];
    platforms = platforms.linux;
  };
}
