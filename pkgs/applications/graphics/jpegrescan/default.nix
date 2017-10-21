{ stdenv, fetchFromGitHub, makeWrapper, libjpeg_turbo, perl, perlPackages }:

stdenv.mkDerivation rec {
  pname = "jpegrescan";
  date = "2016-06-01";
  name = "${pname}-${date}";

  src = fetchFromGitHub {
    owner = "kud";
    repo = pname;
    rev = "e5e39cd972b48ccfb2cba4da6855c511385c05f9";
    sha256 = "0jbx1vzkzif6yjx1fnsm7fjsmq166sh7mn22lf01ll7s245nmpdp";
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

    wrapProgram $out/bin/jpegrescan --prefix PERL5LIB : $PERL5LIB
  '';

  propagatedBuildInputs = [ perlPackages.FileSlurp ];

  buildInputs = [
    perl libjpeg_turbo makeWrapper
  ];

  meta = with stdenv.lib; {
    description = "losslessly shrink any JPEG file";
    homepage = https://github.com/kud/jpegrescan;
    license = licenses.publicDomain;
    maintainers = [ maintainers.ramkromberg ];
    platforms = platforms.all;
  };
}
