{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  qt6,
  desktop-file-utils,
  appstream,
  brother-pe-core,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "embroid";
  version = "0.4.1";

  src = fetchFromGitLab {
    owner = "dlarochette";
    repo = "embroid";
    tag = finalAttrs.version;
    hash = "sha256-l7GfnoedK0mCm0semJJ+w2J/KIhm971KPq1j0HSTXUk=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    brother-pe-core
    qt6.qtbase
  ];

  cmakeFlags = [ (lib.cmakeFeature "EMBROID_QT_VERSION" "6") ];

  doCheck = true;

  nativeCheckInputs = [
    desktop-file-utils
    appstream
  ];

  # GUI tests run offscreen and write QSettings to HOME.
  preCheck = ''
    export HOME=$TMPDIR QT_QPA_PLATFORM=offscreen
    desktop-file-validate ../packaging/embroid.desktop
    appstreamcli validate --no-net ../packaging/io.gitlab.dlarochette.Embroid.metainfo.xml
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Qt application for Brother embroidery cards and designs";
    longDescription = ''
      Embroid replaces PED-Basic on Linux: browse embroidery designs (PES, PEC,
      DST, EXP, JEF, VP3, XXX, G-code) with thumbnails, preview them in the hoop
      at actual size with a stitch simulation, move, rotate, mirror, scale,
      print and export them, compose, write, read, back up and restore Brother
      embroidery cards with the USB card writer (04f9:2100), and send G-code to
      DIY embroidery machines. On NixOS, add brother-pe-core to
      services.udev.packages for access to the reader.
    '';
    homepage = "https://gitlab.com/dlarochette/embroid";
    changelog = "https://gitlab.com/dlarochette/embroid/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dlarochette ];
    mainProgram = "embroid";
    platforms = lib.platforms.linux;
  };
})
