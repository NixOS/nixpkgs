{ stdenv, fetchFromGitHub, qmake
, coreutils, xdg_utils, bash
, makeWrapper, perlPackages, mkDerivation }:

let
  version = "1.6";
in mkDerivation rec {
  pname = "qdirstat";
  inherit version;

  src = fetchFromGitHub {
    owner = "shundhammer";
    repo = "qdirstat";
    rev = version;
    sha256 = "0q4ccjmlbqifg251kyxwys8wspdskr8scqhacyfrs9cmnjxcjqan";
  };

  nativeBuildInputs = [ qmake makeWrapper ];

  buildInputs = [ perlPackages.perl ];

  preBuild = ''
    substituteInPlace scripts/scripts.pro \
      --replace /bin/true ${coreutils}/bin/true

    for i in src/SysUtil.cpp src/FileSizeStatsWindow.cpp
    do
      substituteInPlace $i \
        --replace /usr/bin/xdg-open ${xdg_utils}/bin/xdg-open
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
  postPatch = ''
    export qmakeFlags="$qmakeFlags INSTALL_PREFIX=$out"
  '';

  postInstall = ''
    wrapProgram $out/bin/qdirstat-cache-writer \
      --set PERL5LIB "${perlPackages.makePerlPath [ perlPackages.URI ]}"
  '';

  meta = with stdenv.lib; {
    description = "Graphical disk usage analyzer";
    homepage = src.meta.homepage;
    license = licenses.gpl2;
    maintainers = with maintainers; [ gnidorah ];
    platforms = platforms.linux;
  };
}
