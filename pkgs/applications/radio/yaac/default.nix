{ ant, fetchsvn, jdk, jre8, lib, makeWrapper, stdenv, unzip }:

stdenv.mkDerivation rec {

  pname = "yaac";
  version = "1.0-beta182";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/yetanotheraprsc/code/trunk/yaac";
    rev = "r229";
    sha256 = "sha256-MZxLbIawq+O8paRrLetK6voDRUZSGsIuMF+K+v57izA=";
  };

  nativeBuildInputs = [ ant jdk makeWrapper unzip ];

  # TODO: Make Desktop Icon

  buildPhase = ''
    runHook preBuild

    ant

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    unzip /build/*/YAAC.zip -d $out

    makeWrapper ${jre8}/bin/java $out/bin/yaac \
      --add-flags "-jar $out/YAAC.jar" \
      --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on' \
      --set _JAVA_AWT_WM_NONREPARENTING 1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Yet Another APRS Client";
    homepage = "https://www.ka2ddo.org/ka2ddo/YAAC.html";
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.dotemup ];
  };

}
