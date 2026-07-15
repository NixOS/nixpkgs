{
  lib,
  fetchFromGitHub,
  stdenv,
  qt6Packages,
  coreutils,
  xdg-utils,
  bash,
  makeWrapper,
  perlPackages,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qdirstat";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "shundhammer";
    repo = "qdirstat";
    rev = finalAttrs.version;
    hash = "sha256-qkXu3W6umAlSVlTXaQT/UmC3gzVt6BVy4EZzLBYI94s=";
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ (with qt6Packages; [
    qmake
    qt5compat
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

  meta = {
    description = "Graphical disk usage analyzer";
    homepage = "https://github.com/shundhammer/qdirstat";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.linux;
    mainProgram = "qdirstat";
  };
})
