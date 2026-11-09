{
  lib,
  stdenv,
  fetchFromGitHub,
  smartmontools,
  adwaita-icon-theme,
  cmake,
  gtkmm3,
  makeWrapper,
  pkg-config,
  # xterm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gsmartcontrol";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "ashaduri";
    repo = "gsmartcontrol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eLzwFZ1PYqijFTxos9Osf7A2v4C8toM+TGV4/bU82NE=";
  };

  patches = [
    ./nixos-update-drivedb-message.patch
  ];

  postPatch = ''
    substituteInPlace data/gsmartcontrol.in.desktop \
      --replace-fail "@CMAKE_INSTALL_FULL_BINDIR@/" ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    gtkmm3
    adwaita-icon-theme
  ];

  enableParallelBuilding = true;

  postFixup = ''
    wrapProgram $out/bin/gsmartcontrol \
      --prefix PATH : ${
        lib.makeBinPath [
          smartmontools
          # xterm # For `update-smart-drivedb`, which does not make sense in NixOS as it tries to overwrite /usr/share/smartmontools/drivedb.h
        ]
      }
  '';

  meta = {
    description = "Hard disk drive health inspection tool";
    longDescription = ''
      GSmartControl is a graphical user interface for smartctl (from
      smartmontools package), which is a tool for querying and controlling
      SMART (Self-Monitoring, Analysis, and Reporting Technology) data on
      modern hard disk drives.

      It allows you to inspect the drive's SMART data to determine its health,
      as well as run various tests on it.
    '';
    homepage = "https://gsmartcontrol.shaduri.dev";
    mainProgram = "gsmartcontrol";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qknight ];
    platforms = lib.platforms.linux;
  };
})
