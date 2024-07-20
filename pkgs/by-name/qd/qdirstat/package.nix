{
  lib,
  fetchFromGitHub,
  libsForQt5,
  coreutils,
  xdg-utils,
  bash,
  makeWrapper,
  perlPackages,
}:

libsForQt5.mkDerivation rec {
  pname = "qdirstat";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "shundhammer";
    repo = "qdirstat";
    rev = version;
    hash = "sha256-pwdmltHDNwUMx1FNOoiXl5Pna0zlKqahmicBCN6UVSU=";
  };

  nativeBuildInputs = [ makeWrapper ] ++ (with libsForQt5; [ qmake ]);

  buildInputs = [ perlPackages.perl ];

  postPatch = ''
    substituteInPlace scripts/scripts.pro \
      --replace /bin/true ${coreutils}/bin/true

    for i in src/SysUtil.cpp src/FileSizeStatsWindow.cpp
    do
      substituteInPlace $i \
        --replace /usr/bin/xdg-open ${xdg-utils}/bin/xdg-open
    done
    for i in src/Cleanup.cpp src/cleanup-config-page.ui
    do
      substituteInPlace $i \
        --replace /bin/bash ${bash}/bin/bash \
        --replace /bin/sh ${bash}/bin/sh
    done
    substituteInPlace src/StdCleanup.cpp \
      --replace /bin/bash ${bash}/bin/bash
  '';

  qmakeFlags = [ "INSTALL_PREFIX=${placeholder "out"}" ];

  postInstall = ''
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
