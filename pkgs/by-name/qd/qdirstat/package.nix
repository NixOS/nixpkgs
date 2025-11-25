{
  lib,
  fetchFromGitHub,
  stdenv,
  libsForQt5,
  coreutils,
  xdg-utils,
  bash,
  makeWrapper,
  perlPackages,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "qdirstat";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "shundhammer";
    repo = "qdirstat";
    rev = version;
    hash = "sha256-pwdmltHDNwUMx1FNOoiXl5Pna0zlKqahmicBCN6UVSU=";
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ (with libsForQt5; [
    qmake
    wrapQtAppsHook
  ]);

  buildInputs = [ perlPackages.perl ];

  postPatch = ''
    substituteInPlace scripts/scripts.pro \
      --replace-fail /bin/true ${coreutils}/bin/true
    substituteInPlace src/SysUtil.cpp src/FileSizeStatsWindow.cpp \
      --replace-fail /usr/bin/xdg-open ${xdg-utils}/bin/xdg-open
    substituteInPlace src/Cleanup.cpp src/cleanup-config-page.ui \
      --replace-fail /bin/bash ${bash}/bin/bash \
      --replace-fail /bin/sh ${bash}/bin/sh
    substituteInPlace src/MountPoints.cpp \
      --replace-fail /bin/lsblk ${util-linux}/bin/lsblk
    substituteInPlace src/StdCleanup.cpp \
      --replace-fail /bin/bash ${bash}/bin/bash
  '';

  qmakeFlags = [ "INSTALL_PREFIX=${placeholder "out"}" ];

  postFixup = ''
    wrapProgram $out/bin/qdirstat-cache-writer \
      --set PERL5LIB "${perlPackages.makePerlPath [ perlPackages.URI ]}"
  '';

  meta = with lib; {
    description = "Graphical disk usage analyzer";
    homepage = "https://github.com/shundhammer/qdirstat";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ donovanglover ];
    platforms = platforms.linux;
    mainProgram = "qdirstat";
  };
}
