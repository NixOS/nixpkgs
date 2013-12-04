{stdenv, fetchurl, jre, unzip}:
stdenv.mkDerivation rec {
  version = "0.8.2";
  pname = "zgrviewer";
  name="${pname}-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/zvtm/${pname}/${version}/${name}.zip";
    sha256 = "a76b9865c1490a6cfc08911592a19c15fe5972bf58e017cb31db580146f069bb";
  };
  buildInputs = [jre unzip];
  buildPhase = "";
  installPhase = ''
    mkdir -p "$out"/{bin,lib/java/zvtm/plugins,share/doc/zvtm}

    cp overview.html *.license.* "$out/share/doc/zvtm"

    cp -r target/* "$out/lib/java/zvtm/"

    echo '#!/bin/sh' > "$out/bin/zgrviewer"
    echo "java -jar '$out/lib/java/zvtm/zgrviewer-${version}.jar'" >> "$out/bin/zgrviewer"
    chmod a+x "$out/bin/zgrviewer"
  '';
  meta = {
    # Quicker to unpack locally than load Hydra
    hydraPlatforms = [];
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = with stdenv.lib.licenses; lgpl21Plus;
    description = "GraphViz graph viewer/navigator";
  };
}
