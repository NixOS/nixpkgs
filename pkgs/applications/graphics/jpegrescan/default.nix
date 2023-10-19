{ lib, stdenv, fetchFromGitHub, makeWrapper, perl, perlPackages, libjpeg_original }:

stdenv.mkDerivation rec {
  pname = "jpegrescan";
  version = "unstable-2019-03-27";

  dontBuild = true;
  dontConfigure = true;

  src = fetchFromGitHub {
    owner = "kud";
    repo = pname;
    rev = "3a7de06feabeb3c3235c3decbe2557893c1abe51";
    sha256 = "0cnl46z28lkqc5x27b8rpghvagahivrqcfvhzcsv9w1qs8qbd6dm";
  };

  patchPhase = ''
    patchShebangs jpegrescan
  '';

  installPhase = ''
    mkdir -p $out/share/jpegrescan
    mv README.md $out/share/jpegrescan/
    mkdir $out/bin
    mv jpegrescan $out/bin
    chmod +x $out/bin/jpegrescan

    wrapProgram $out/bin/jpegrescan \
      --prefix PATH : "${libjpeg_original}/bin:" \
      --prefix PERL5LIB : $PERL5LIB
  '';

  propagatedBuildInputs = [ perlPackages.FileSlurp ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ];

  meta = with lib; {
    description = "Losslessly shrink any JPEG file";
    homepage = "https://github.com/kud/jpegrescan";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ ramkromberg ];
    platforms = platforms.all;
    mainProgram = "jpegrescan";
  };
}
