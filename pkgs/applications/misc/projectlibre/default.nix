{ stdenv, fetchgit, ant, jdk, jre }:

stdenv.mkDerivation rec {
  name = "projectlibre-${version}";
  version = "1.6.2";

  src = fetchgit {
    url = "https://git.code.sf.net/p/projectlibre/code";
    rev = "refs/tags/v${version}";
    sha256 = "0zwxclhq7gk5l09q5039yywn9b9d7yxm8mjjdxaq93y0pf3q3fcw";
  };

  buildInputs = [ ant jdk ];
  buildPhase = ''
    export ANT_OPTS=-Dbuild.sysclasspath=ignore
    ${ant}/bin/ant -f openproj_build/build.xml
  '';

  resourcesPath = "openproj_build/resources";
  desktopItem = "${resourcesPath}/projectlibre.desktop";

  installPhase = ''
    mkdir -p $out/share/{applications,projectlibre/samples,pixmaps} $out/bin
    substitute $resourcesPath/projectlibre $out/bin/projectlibre \
      --replace "\"/usr/share/projectlibre\"" "\"$out/share/projectlibre\"" \
      --replace "JAVA_EXE=\"java\"" "JAVA_EXE=\"${jre}/bin/java\""
    chmod +x $out/bin/projectlibre
    cp -R openproj_build/dist/* $out/share/projectlibre
    cp $desktopItem $out/share/applications
    cp $resourcesPath/projectlibre.png $out/share/pixmaps
    cp -R $resourcesPath/samples/* $out/share/projectlibre/samples
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.projectlibre.com/";
    descripton = "Project-Management Software similar to MS-Project";
    maintainer = maintainers.mogria;
    license = licenses.cpal10;
  };
}
