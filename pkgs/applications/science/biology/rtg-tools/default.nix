{ config, lib, pkgs, stdenv, fetchFromGitHub, jdk, ant, git, unzip }:

stdenv.mkDerivation rec {
  pname = "rtg-tools";
  version = "3.12.1";

  src = fetchFromGitHub {
    owner = "RealTimeGenomics";
    repo = "rtg-tools";
    rev = version;
    sha256 = "sha256-fMrrjrgaGxBVxn6qMq2g0oFv6qtfhZcQlkvv1E9Os6Y=";
  };

  patches = [
    ./ant.patch
  ];

  nativeBuildInputs = [
    ant
    jdk
    git
    unzip
  ];

  buildPhase = ''
    ant rtg-tools.jar
  '';

  installPhase =''
    mkdir -p $out/bin
    cp build/rtg-tools.jar $out/bin/RTG.jar
    cp installer/rtg $out/bin/
  '';

  fixupPhase = ''
    # Use a location outside nix (must be writable)
    sed -i 's|$THIS_DIR/rtg.cfg|$HOME/.rtg.cfg|g' $out/bin/rtg
    # Use nix java
    sed -i 's|RTG_JAVA="java".*|RTG_JAVA="${jdk}/lib/openjdk/bin/java"  # Nix Path to java|' $out/bin/rtg
  '';

  meta = with lib; {
    homepage = "https://github.com/RealTimeGenomics/rtg-tools/";
    description = "Useful utilities for dealing with VCF files and sequence data, especially vcfeval";
    license = licenses.bsd2;
    platforms = [  "x86_64-linux" ];
    maintainers = with maintainers; [ apraga ];
  };
}
