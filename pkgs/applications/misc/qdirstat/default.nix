{ lib, fetchFromGitHub, qmake
, coreutils, xdg-utils, bash
, makeWrapper, perlPackages, mkDerivation }:

let
  pname = "qdirstat";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "shundhammer";
    repo = pname;
    rev = version;
    sha256 = "sha256-yWv41iWtdTdlFuvLHKCbwmnSXq7Z5pIJq28GMDltdxM=";
  };
in

mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ qmake makeWrapper ];

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
    homepage = src.meta.homepage;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
