{
  mkDerivation,
  lib,
  fetchFromGitHub,
  cmake,
  python3,
  qtbase,
  qtquickcontrols2,
  qtgraphicaleffects,
  curaengine,
  plugins ? [ ],
}:

mkDerivation rec {
  pname = "cura";
  version = "4.13.1";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Cura";
    rev = version;
    sha256 = "sha256-R88SdAxx3tkQCDInrFTKad1tPSDTSYaVAPUVmdk94Xk=";
  };

  materials = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "fdm_materials";
    rev = "4.13.2";
    sha256 = "sha256-7y4OcbeQHv+loJ4cMgPU0e818Zsv90EwARdztNWS8zM=";
  };

  buildInputs = [
    qtbase
    qtquickcontrols2
    qtgraphicaleffects
  ];
  propagatedBuildInputs =
    with python3.pkgs;
    [
      libsavitar
      numpy-stl
      pyserial
      requests
      uranium
      zeroconf
      pynest2d
      sentry-sdk
      trimesh
      keyring
    ]
    ++ plugins;
  nativeBuildInputs = [
    cmake
    python3.pkgs.wrapPython
  ];

  cmakeFlags = [
    "-DURANIUM_DIR=${python3.pkgs.uranium.src}"
    "-DCURA_VERSION=${version}"
  ];

  makeWrapperArgs = [
    # hacky workaround for https://github.com/NixOS/nixpkgs/issues/59901
    "--set OMP_NUM_THREADS 1"
  ];

  postPatch = ''
    sed -i 's,/python''${PYTHON_VERSION_MAJOR}/dist-packages,/python''${PYTHON_VERSION_MAJOR}.''${PYTHON_VERSION_MINOR}/site-packages,g' CMakeLists.txt
    sed -i 's, executable_name = .*, executable_name = "${curaengine}/bin/CuraEngine",' plugins/CuraEngineBackend/CuraEngineBackend.py
  '';

  postInstall = ''
    mkdir -p $out/share/cura/resources/materials
    cp ${materials}/*.fdm_material $out/share/cura/resources/materials/
    mkdir -p $out/lib/cura/plugins
    for plugin in ${toString plugins}; do
      ln -s $plugin/lib/cura/plugins/* $out/lib/cura/plugins
    done
  '';

  postFixup = ''
    wrapPythonPrograms
    wrapQtApp $out/bin/cura
  '';

  meta = with lib; {
    description = "3D printer / slicing GUI built on top of the Uranium framework";
    mainProgram = "cura";
    homepage = "https://github.com/Ultimaker/Cura";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
