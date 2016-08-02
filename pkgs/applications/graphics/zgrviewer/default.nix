{stdenv, fetchurl, jre, unzip}:
stdenv.mkDerivation rec {
  version = "0.9.0";
  pname = "zgrviewer";
  name="${pname}-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/zvtm/${pname}/${version}/${name}.zip";
    sha256 = "1yg2rck81sqqrgfi5kn6c1bz42dr7d0zqpcsdjhicssi1y159f23";
  };
  buildInputs = [jre unzip];
  buildPhase = "";
  installPhase = ''
    mkdir -p "$out"/{bin,share/java/zvtm/plugins,share/doc/zvtm}

    cp overview.html *.license.* "$out/share/doc/zvtm"

    cp -r target/* "$out/share/java/zvtm/"

    echo '#!/bin/sh' > "$out/bin/zgrviewer"
    echo "java -jar '$out/share/java/zvtm/zgrviewer-${version}.jar'" >> "$out/bin/zgrviewer"
    chmod a+x "$out/bin/zgrviewer"
  '';
  meta = {
    # Quicker to unpack locally than load Hydra
    hydraPlatforms = [];
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = stdenv.lib.licenses.lgpl21Plus;
    description = "GraphViz graph viewer/navigator";
    platforms = with stdenv.lib.platforms; unix;
  };
}
