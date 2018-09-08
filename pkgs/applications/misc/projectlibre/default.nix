{ stdenv, fetchgit, ant, jdk, makeWrapper, jre, coreutils, which }:

stdenv.mkDerivation rec {
  name = "projectlibre-${version}";
  version = "1.7.0";

  src = fetchgit {
    url = "https://git.code.sf.net/p/projectlibre/code";
    rev = "0c939507cc63e9eaeb855437189cdec79e9386c2"; # version 1.7.0 was not tagged
    sha256 = "0vy5vgbp45ai957gaby2dj1hvmbxfdlfnwcanwqm9f8q16qipdbq";
  };

  buildInputs = [ ant jdk makeWrapper ];
  buildPhase = ''
    export ANT_OPTS=-Dbuild.sysclasspath=ignore
    ${ant}/bin/ant -f openproj_build/build.xml
  '';

  resourcesPath = "openproj_build/resources";
  desktopItem = "${resourcesPath}/projectlibre.desktop";

  installPhase = ''
    mkdir -p $out/share/{applications,projectlibre/samples,pixmaps,doc/projectlibre} $out/bin

    substitute $resourcesPath/projectlibre $out/bin/projectlibre \
      --replace "\"/usr/share/projectlibre\"" "\"$out/share/projectlibre\""
    chmod +x $out/bin/projectlibre
    wrapProgram $out/bin/projectlibre \
     --prefix PATH : "${jre}/bin:${coreutils}/bin:${which}/bin"

    cp -R openproj_build/dist/* $out/share/projectlibre
    cp -R openproj_build/license $out/share/doc/projectlibre
    cp $desktopItem $out/share/applications
    cp $resourcesPath/projectlibre.png $out/share/pixmaps
    cp -R $resourcesPath/samples/* $out/share/projectlibre/samples
  '';

  meta = with stdenv.lib; {
    homepage = http://www.projectlibre.com/;
    description = "Project-Management Software similar to MS-Project";
    maintainers = [ maintainers.Mogria ];
    license = licenses.cpal10;
  };
}
