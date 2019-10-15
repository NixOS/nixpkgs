{ mkDerivation, lib, fetchFromGitHub, cmake, python3, qtbase, qtquickcontrols2, qtgraphicaleffects, curaengine, plugins ? [] }:

mkDerivation rec {
  pname = "cura";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Cura";
    rev = version;
    sha256 = "1qnai8vmgy5lx3lapw96j41i8mw9p6r99i3qzs709l9yzrix6l86";
  };

  materials = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "fdm_materials";
    rev = version;
    sha256 = "141cv1f2pv2pznhgj32zg8bw3kmw9002g6rx16jq7lhclr0x3xls";
  };

  buildInputs = [ qtbase qtquickcontrols2 qtgraphicaleffects ];
  propagatedBuildInputs = with python3.pkgs; [
    libsavitar numpy-stl pyserial requests uranium zeroconf
  ] ++ plugins;
  nativeBuildInputs = [ cmake python3.pkgs.wrapPython ];

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
    homepage = https://github.com/Ultimaker/Cura;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
