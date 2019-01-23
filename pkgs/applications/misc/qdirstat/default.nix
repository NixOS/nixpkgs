{ stdenv, fetchFromGitHub, qmake
, coreutils, xdg_utils, bash
, makeWrapper, perlPackages }:

let
  version = "1.4";
in stdenv.mkDerivation rec {
  name = "qdirstat-${version}";

  src = fetchFromGitHub {
    owner = "shundhammer";
    repo = "qdirstat";
    rev = "${version}";
    sha256 = "1ppasbr0mq301q6n3rm0bsmprs7vgkcjmmc0gbgqpgw84nmp9fqh";
  };

  nativeBuildInputs = [ qmake makeWrapper ];

  buildInputs = [ perlPackages.perl ];

  preBuild = ''
    substituteInPlace scripts/scripts.pro \
      --replace /bin/true ${coreutils}/bin/true \
      --replace /usr/bin $out/bin
    substituteInPlace src/src.pro \
      --replace /usr/bin $out/bin \
      --replace /usr/share $out/share
    for i in doc/doc.pro doc/stats/stats.pro
    do
      substituteInPlace $i \
        --replace /usr/share $out/share
    done

    for i in src/MainWindow.cpp src/FileSizeStatsWindow.cpp
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
