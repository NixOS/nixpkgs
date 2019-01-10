{ stdenv, lib, makeWrapper, fetchurl, unzip, openjdk }:

stdenv.mkDerivation rec {
  name = "bftools-${version}";
  version = "5.9.2";

  src = fetchurl {
    url = "http://downloads.openmicroscopy.org/bio-formats/${version}/artifacts/bftools.zip";
    sha256 = "02x8p07z7js41kgiblkr9k8v9v4ka8rm7pg3f1vy9s5p6hmpfvnx";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $(find ./* -maxdepth 1 ! -path "*.bat") $out/
  '';

  postFixup = ''
    for script in "$out"/bin/*; do
      wrapProgram "$script" --prefix PATH : "${lib.makeBinPath [ openjdk ]}"
    done
  '';

  buildInputs = [ unzip ];

  nativeBuildInputs = [ makeWrapper ];

  meta = with stdenv.lib; {
    description = "A bundle of scripts for using Bio-Formats on the command line with bioformats_package.jar already included";
    license = licenses.gpl2;
    platforms = platforms.all;
    homepage = https://www.openmicroscopy.org/bio-formats/;
    maintainers = [ maintainers.tbenst ];
  };
}
