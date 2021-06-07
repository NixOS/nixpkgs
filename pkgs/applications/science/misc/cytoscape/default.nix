{ lib, stdenv, fetchurl, jre, makeWrapper, substituteAll, coreutils }:

stdenv.mkDerivation rec {
  pname = "cytoscape";
  version = "3.8.2";

  src = fetchurl {
    url = "https://github.com/cytoscape/cytoscape/releases/download/${version}/${pname}-unix-${version}.tar.gz";
    sha256 = "0zgsq9qnyvmq96pgf7372r16rm034fd0r4qa72xi9zbd4f2r7z8w";
  };

  patches = [
    # By default, gen_vmoptions.sh tries to store custom options in $out/share
    # at run time. This patch makes sure $HOME is used instead.
    (substituteAll {
      src = ./gen_vmoptions_to_homedir.patch;
      inherit coreutils;
    })
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    mkdir -pv $out/{share,bin}
    cp -Rv * $out/share/

    ln -s $out/share/cytoscape.sh $out/bin/cytoscape

    wrapProgram $out/share/cytoscape.sh \
      --set JAVA_HOME "${jre}" \
      --set JAVA  "${jre}/bin/java"

    chmod +x $out/bin/cytoscape
  '';

  meta = {
    homepage = "http://www.cytoscape.org";
    description = "A general platform for complex network analysis and visualization";
    license = lib.licenses.lgpl21;
    maintainers = [lib.maintainers.mimame];
    platforms = lib.platforms.unix;
  };
}
