{
  lib,
  fetchFromBitbucket,
  python3,
  nix-update-script,
  python3Packages,
  libsForQt5,
}:

python3Packages.buildPythonApplication {
  pname = "flatcam";
  version = "0-unstable-2022-01-02";

  format = "other";

  src = fetchFromBitbucket {
    owner = "jpcgt";
    repo = "flatcam";
    rev = "ebf5cb9e3094362c4b0774a54cf119559c02211d";
    hash = "sha256-QKkBPEM+HVYmSZ83b4JRmOmCMp7C3EUqbJKPqUXMiKE=";
  };

  patches = [
    ./0001-fix-treewide-replace-np.Inf-with-np.inf.patch
    ./0002-fix-tclCommands-migrate-to-importlib.patch
    ./0003-fix-treewide-use-raw-strings-for-regex.patch
    ./0004-fix-vispy-Comment-out-crossed-lines-marker-patch.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    libsForQt5.qt5.wrapQtAppsHook
  ];
  dependencies = with python3Packages; [
    pyqt5
    numpy
    matplotlib
    cycler
    python-dateutil
    kiwisolver
    six
    setuptools
    dill
    rtree
    pyopengl
    vispy
    ortools
    svg-path
    simplejson
    shapely
    freetype-py
    fonttools
    rasterio
    lxml
    ezdxf
    qrcode
    reportlab
    svglib
    gdal
    pyserial

    # Not listed in requirements but definitely still required
    protobuf
  ];

  postPatch = ''
    rm Makefile
    patchShebangs .
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor/scalable/apps $out/${python3.sitePackages}/flatcam

    cp -r . $out/${python3.sitePackages}/flatcam

    ln -s $out/${python3.sitePackages}/flatcam/assets/linux/flatcam-beta $out/bin/flatcam-beta
    ln -s $out/${python3.sitePackages}/flatcam/assets/linux/flatcam-beta.desktop $out/share/applications
    ln -s $out/${python3.sitePackages}/flatcam/assets/linux/icon.png $out/share/icons/hicolor/scalable/apps/rofi.png

    runHook postInstall
  '';

  dontWrapQtApps = true;
  postFixup = ''
    sed -i "s|\.|$out|g" "$out/${python3.sitePackages}/flatcam/assets/linux/flatcam-beta.desktop"
    # https://github.com/NixOS/nixpkgs/issues/269198
    wrapQtApp "$out/${python3.sitePackages}/flatcam/assets/linux/flatcam-beta" \
      --prefix PATH : "$program_PATH" \
      --prefix PYTHONPATH : "$program_PYTHONPATH"
  '';

  doCheck = false;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "2-D post processing for manufacturing, specializing in Printed Circuit Board fabrication on CNC routers";
    homepage = "http://flatcam.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
    mainProgram = "flatcam-beta";
  };
}
