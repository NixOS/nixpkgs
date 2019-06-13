{ mkDerivation, lib, fetchFromGitHub, cmake, python3, qtbase, qtquickcontrols2, qtgraphicaleffects, curaengine }:

mkDerivation rec {
  name = "cura-${version}";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Cura";
    rev = version;
    sha256 = "1mfpnjrh3splpkadgml3v71k939g56zb9hbmzghwfjwlrf8valmz";
  };

  materials = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "fdm_materials";
    rev = version;
    sha256 = "0yp2162msxfwpixzvassn23p7r3swjpwk4nhsjka5w6fm8pv0wpl";
  };

  buildInputs = [ qtbase qtquickcontrols2 qtgraphicaleffects ];
  propagatedBuildInputs = with python3.pkgs; [
    libsavitar numpy-stl pyserial requests uranium zeroconf
  ];
  nativeBuildInputs = [ cmake python3.pkgs.wrapPython ];

  cmakeFlags = [
    "-DURANIUM_DIR=${python3.pkgs.uranium.src}"
    "-DCURA_VERSION=${version}"
  ];

  postPatch = ''
    sed -i 's,/python''${PYTHON_VERSION_MAJOR}/dist-packages,/python''${PYTHON_VERSION_MAJOR}.''${PYTHON_VERSION_MINOR}/site-packages,g' CMakeLists.txt
    sed -i 's, executable_name = .*, executable_name = "${curaengine}/bin/CuraEngine",' plugins/CuraEngineBackend/CuraEngineBackend.py
  '';

  postInstall = ''
    mkdir -p $out/share/cura/resources/materials
    cp ${materials}/*.fdm_material $out/share/cura/resources/materials/
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "3D printer / slicing GUI built on top of the Uranium framework";
    homepage = https://github.com/Ultimaker/Cura;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
