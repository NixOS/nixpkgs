{
  lib,
  stdenv,
  fetchurl,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libguytools";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/libguytools/libguytools/LatestSource/tools-${finalAttrs.version}.tar.gz";
    hash = "sha256-eVYvjo2wKW2g9/9hL9nbQa1FRWDMMqMHok0V/adPHVY=";
  };

  qmakeFlags = [
    "trunk.pro"
    "toolsstatic.pro"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];
  dontWrapQtApps = true;
  buildInputs = [ libsForQt5.qtbase ];

  postPatch = ''
    sed -i "/dpkg-buildflags/d" tools.pro
    patchShebangs create_version_file.sh
  '';

  preConfigure = ''
    ./create_version_file.sh
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r lib $out/
    cp -r include $out/
    runHook postInstall
  '';

  meta = {
    description = "Small programming toolbox";
    mainProgram = "libguytools";
    homepage = "https://libguytools.sourceforge.io";
    maintainers = with lib.maintainers; [ d3vil0p3r ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
})
