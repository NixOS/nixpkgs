{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "kotatsu-dl";
  version = "0.5";

  src = pkgs.fetchurl {
    url = "https://github.com/KotatsuApp/kotatsu-dl/releases/download/v${version}/kotatsu-dl.jar";
    sha256 = "sha256-GI/PLt8wbVs2R78PbQg/9/Rea33j6CFQjuqhYIQGimM=";
  };

  # Skip the unpackPhase since it's just a JAR file, not an archive
  phases = [ "installPhase" ];

  # Java Runtime
  buildInputs = [ pkgs.openjdk ];
  propagatedBuildInputs = [ pkgs.openjdk ];

  installPhase = ''
    # Create directory for the binary
    mkdir -p $out/bin
    mkdir -p $out/share/java

    # Copy the JAR file to the bin directory
    cp $src $out/share/java/kotatsu-dl.jar

    # Create an executable wrapper to run the JAR file
    cat > $out/bin/kotatsu-dl <<EOF
    #!/bin/sh
    exec ${pkgs.openjdk}/bin/java -jar $out/share/java/kotatsu-dl.jar "\$@"
    EOF

    # Make the wrapper executable
    chmod +x $out/bin/kotatsu-dl
  '';

  meta = with pkgs.lib; {
    description = "Easy-to-use cli manga downloader with a 1k+ sources supported";
    license = licenses.gpl3;
  };
}
