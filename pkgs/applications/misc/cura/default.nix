{ mkDerivation, lib, fetchFromGitHub, cmake, python3, qtbase,
 qtquickcontrols2, qtgraphicaleffects, curaengine, plugins ? [] }:

mkDerivation rec {
  pname = "cura";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Cura";
    rev = version;
    sha256 = "sha256-Mt9fLJVD39QSjnUakfeCmwKfJZQSd2O9OzAiyGB2jpQ=";
  };

  materials = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "fdm_materials";
    rev = version;
    sha256 = "sha256-BZHPyKZePBGqd8loiknE0qUoLJCUy6cxBII598Eilg4";
  };

  buildInputs = [ qtbase qtquickcontrols2 qtgraphicaleffects ];
  propagatedBuildInputs = with python3.pkgs; [
    libsavitar numpy-stl pyserial requests uranium zeroconf pynest2d
    sentry-sdk trimesh keyring pyqt6
  ] ++ plugins;
  nativeBuildInputs = [ cmake python3.pkgs.wrapPython ];

  cmakeFlags = [
    "-DURANIUM_DIR=${python3.pkgs.uranium.src}"
    "-DCURA_VERSION=${version}"
    "-DPython_SITELIB_LOCAL=${python3.sitePackages}"
  ];

  makeWrapperArgs = [
    # hacky workaround for https://github.com/NixOS/nixpkgs/issues/59901
    "--set OMP_NUM_THREADS 1"
  ];

  prePatch = ''
  substituteInPlace CMakeLists.txt --replace cura/CuraVersion.py.in CuraVersion.py.jinja
  substituteInPlace CuraVersion.py.jinja \
    --replace '{{ cura_debug_mode }}' False \
    --replace '{{ cura_version }}' '${version}'
  '';

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
    ls $out
    ls $out/bin
    ls $out/lib
    wrapPythonPrograms
    wrapQtApp $out/bin/cura_app.py
    ln -s $out/bin/cura_app.py $out/bin/cura
  '';

  meta = with lib; {
    description = "3D printer / slicing GUI built on top of the Uranium framework";
    homepage = "https://github.com/Ultimaker/Cura";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
