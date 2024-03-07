{ lib, stdenv, fetchurl, jre, unzip, runtimeShell }:
stdenv.mkDerivation rec {
  version = "0.9.0";
  pname = "zgrviewer";
  src = fetchurl {
    url = "mirror://sourceforge/zvtm/${pname}/${version}/${pname}-${version}.zip";
    sha256 = "1yg2rck81sqqrgfi5kn6c1bz42dr7d0zqpcsdjhicssi1y159f23";
  };
  nativeBuildInputs = [ unzip ];
  buildInputs = [jre];
  buildPhase = "";
  installPhase = ''
    mkdir -p "$out"/{bin,share/java/zvtm/plugins,share/doc/zvtm}

    cp overview.html *.license.* "$out/share/doc/zvtm"

    cp -r target/* "$out/share/java/zvtm/"

    echo '#!${runtimeShell}' > "$out/bin/zgrviewer"
    echo "${jre}/bin/java -jar '$out/share/java/zvtm/zgrviewer-${version}.jar' \"\$@\"" >> "$out/bin/zgrviewer"
    chmod a+x "$out/bin/zgrviewer"
  '';
  meta = {
    # Quicker to unpack locally than load Hydra
    hydraPlatforms = [];
    maintainers = with lib.maintainers; [raskin];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.lgpl21Plus;
    description = "GraphViz graph viewer/navigator";
    platforms = with lib.platforms; unix;
    mainProgram = "zgrviewer";
  };
}
