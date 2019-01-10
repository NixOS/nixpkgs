{ stdenv, lib, makeWrapper, fetchzip, jre }:

stdenv.mkDerivation rec {
  name = "bftools-${version}";
  version = "5.9.2";

  src = fetchzip {
    url = "http://downloads.openmicroscopy.org/bio-formats/${version}/artifacts/bftools.zip";
    sha256 = "08lmbg3kfxh17q6548il0i2h3f9a6ch8r0r067p14dajhzfpjyqj";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $(find ./* -maxdepth 1 ! -path "*.bat") $out/bin
  '';

  postFixup = ''
    chmod +x $out/bin/bf.sh
    wrapProgram $out/bin/bf.sh --prefix PATH : "${lib.makeBinPath [ jre ]}"
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = with stdenv.lib; {
    description = "A bundle of scripts for using Bio-Formats on the command line with bioformats_package.jar already included";
    license = licenses.gpl2;
    platforms = platforms.all;
    homepage = https://www.openmicroscopy.org/bio-formats/;
    maintainers = [ maintainers.tbenst ];
  };
}
