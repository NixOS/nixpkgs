{ stdenv, lib, pkgs, fetchurl, unzip, openjdk }:

stdenv.mkDerivation rec {
  name = "bftools-${version}";
  version = "5.9.2";

  src = fetchurl {
    url = "http://downloads.openmicroscopy.org/bio-formats/${version}/artifacts/bftools.zip";
    sha256 = "02x8p07z7js41kgiblkr9k8v9v4ka8rm7pg3f1vy9s5p6hmpfvnx";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ./* $out/
    for script in $(find . -maxdepth 1 -perm -111 -type f); do
      ln -s $out/$script $out/bin/$script
    done
  '';

  postFixup = ''
        for script in "$out"/bin/*; do
          wrapProgram "$script" --prefix PATH : "${lib.makeBinPath [ openjdk ]}"
        done
      '';

  buildInputs = [ unzip pkgs.makeWrapper ];

  # phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  meta = with stdenv.lib; {
    description = "A bundle of scripts for using Bio-Formats on the command line with bioformats_package.jar already included.";
    license = licenses.gpl3;
    homepage = https://www.openmicroscopy.org/bio-formats/;
    maintainers = [ maintainers.tbenst ];
  };
}
