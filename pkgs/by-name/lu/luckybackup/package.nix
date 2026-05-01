{
  lib,
  fetchurl,
  libtool,
  openssh,
  pkg-config,
  qt5,
  rsync,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "luckybackup";
  version = "0.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/luckybackup/${finalAttrs.version}/source/luckybackup-${finalAttrs.version}.tar.gz";
    hash = "sha256-6AGvJIPL3WK8mvji3tJSxRrbrYFILikQQvWOIcPUkls=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  nativeBuildInputs = [
    libtool
    pkg-config
    qt5.qmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    rsync
    openssh
    qt5.qtwayland
  ];

  strictDeps = true;

  prePatch = ''
    for File in \
      luckybackup.pro \
      menu/luckybackup-pkexec \
      menu/luckybackup-su.desktop \
      menu/luckybackup.desktop \
      menu/net.luckybackup.su.policy \
      src/functions.cpp \
      src/global.cpp \
      src/scheduleDialog.cpp; do
        substituteInPlace $File --replace "/usr" "$out"
    done
  '';

  meta = {
    homepage = "https://luckybackup.sourceforge.net/";
    description = "Powerful, fast and reliable backup & sync tool";
    longDescription = ''
      luckyBackup is an application for data back-up and synchronization
      powered by the rsync tool.

      It is simple to use, fast (transfers over only changes made and not
      all data), safe (keeps your data safe by checking all declared directories
      before proceeding in any data manipulation), reliable and fully
      customizable.
    '';
    license = lib.licenses.gpl3Plus;
    mainProgram = "luckybackup";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
