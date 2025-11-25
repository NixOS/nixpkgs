{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapQtAppsHook,
  cmake,
  bzip2,
  qtbase,
  qttools,
  libnova,
  proj,
  libpng,
  openjpeg,
}:

stdenv.mkDerivation {
  version = "unstable-2022-05-16";
  pname = "xygrib";

  src = fetchFromGitHub {
    owner = "opengribs";
    repo = "XyGrib";
    rev = "88c425ca2d7f4ba5d7ab75bfa25e177bee02d310";
    sha256 = "sha256-qMMeRYIQqJpVRE3YjbXIiXHwS/CHs9l2QihszwQIr/A=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];
  buildInputs = [
    bzip2
    qtbase
    libnova
    proj
    openjpeg
    libpng
  ];
  cmakeFlags = [
    "-DOPENJPEG_INCLUDE_DIR=${openjpeg.dev}/include/openjpeg-${lib.versions.majorMinor openjpeg.version}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "-DLIBNOVA_LIBRARY=${libnova}/lib/libnova.dylib" ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 3.1.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p "$out/Applications" "$out/XyGrib/XyGrib.app/Contents/Resources"
        cp "../data/img/xyGrib.icns" "$out/XyGrib/XyGrib.app/Contents/Resources/xyGrib.icns"
        mv $out/XyGrib/XyGrib.app $out/Applications
        wrapQtApp "$out/Applications/XyGrib.app/Contents/MacOS/XyGrib"
      ''
    else
      ''
        wrapQtApp $out/XyGrib/XyGrib
        mkdir -p $out/bin
        ln -s $out/XyGrib/XyGrib $out/bin/xygrib
        install -Dm444 $src/debian/xygrib.png -t $out/share/icons/hicolor/32x32/apps
        install -Dm444 $src/debian/xygrib.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/xygrib.desktop \
          --replace 'Exec=XyGrib' 'Exec=xygrib'
      '';

  meta = with lib; {
    homepage = "https://opengribs.org";
    description = "Weather Forecast Visualization";
    mainProgram = "xygrib";
    longDescription = ''
      XyGrib is a leading opensource weather visualization package.
      It interacts with OpenGribs's Grib server providing a choice
      of global and large area atmospheric and wave models.
    '';
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
