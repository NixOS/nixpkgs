{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  perl,
  perlPackages,
  bluez,
}:

stdenv.mkDerivation rec {
  pname = "bt-fw-converter";
  version = "2017-02-19";
  rev = "2d8b34402df01c6f7f4b8622de9e8b82fadf4153";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/winterheart/broadcom-bt-firmware/${rev}/tools/bt-fw-converter.pl";
    sha256 = "c259b414a4a273c89a0fa7159b3ef73d1ea62b6de91c3a7c2fcc832868e39f4b";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    perl
    perlPackages.RegexpGrammars
    bluez
  ];

  unpackCmd = ''
    mkdir -p ${pname}-${version}
    cp $src ${pname}-${version}/bt-fw-converter.pl
  '';

  installPhase = ''
    install -D -m755 bt-fw-converter.pl $out/bin/bt-fw-converter
    substituteInPlace $out/bin/bt-fw-converter --replace /usr/bin/hex2hcd ${bluez}/bin/hex2hcd
    wrapProgram $out/bin/bt-fw-converter --set PERL5LIB $PERL5LIB
  '';

  meta = with lib; {
    homepage = "https://github.com/winterheart/broadcom-bt-firmware/";
    description = "Tool that converts hex to hcd based on inf file";
    mainProgram = "bt-fw-converter";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zraexy ];
  };
}
