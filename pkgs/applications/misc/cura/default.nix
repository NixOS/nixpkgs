{ mkDerivation, lib, fetchFromGitHub, cmake, python3, qtbase,
 qtquickcontrols2, qtgraphicaleffects, curaengine, plugins ? [] }:

mkDerivation rec {
  pname = "cura";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Cura";
    rev = version;
    sha256 = "01qjxjdzp4n8rs5phwi3kdkf222w4qwcfnb7mvfawyd2yakqim6h";
  };

  materials = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "fdm_materials";
    rev = "5.2.0";
    sha256 = "0xn6mdn3kwabssad8rpmnmx3kgzh9ldy0kgb6qr2bcd6cklg4anp";
  };

  buildInputs = [ qtbase qtquickcontrols2 qtgraphicaleffects ];
  propagatedBuildInputs = with python3.pkgs; [
    keyring
    # libsavitar # TODO? Alpine apparently currently ignores it, see: https://git.alpinelinux.org/aports/tree/testing/cura/APKBUILD?id=2474a2fc7f819a7c8a31ccc561b95955dec5101f
    numpy-stl
    pynest2d
    pyqt6
    pyserial
    requests
    sentry-sdk
    trimesh
    uranium
    zeroconf
  ] ++ plugins;
  nativeBuildInputs = [ cmake python3.pkgs.wrapPython ];

  cmakeFlags = [
    "-DURANIUM_DIR=${python3.pkgs.uranium.src}"
    "-DCURA_VERSION=${version}"
    # The upstream code checks for an exact python version and errors out
    # if we don't have that and do not pass `Python_VERSION` explicitly.
    "-DPython_VERSION=${python3.pythonVersion}"
    # Set install location to not be the global Python install dir
    # (which is read-only in the nix store); see:
    "-DPython_SITELIB_LOCAL=${placeholder "out"}/${python3.sitePackages}"
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

    # find $out/bin
    # exit 1

    wrapQtApp $out/bin/cura_app.py
  '';

  meta = with lib; {
    description = "3D printer / slicing GUI built on top of the Uranium framework";
    homepage = "https://github.com/Ultimaker/Cura";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
