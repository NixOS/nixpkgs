{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonPackage rec {
  pname = "pydf";
  version = "12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f47a7c3abfceb1ac04fc009ded538df1ae449c31203962a1471a4eb3bf21439";
  };

  postInstall = ''
    mkdir -p $out/share/man/man1 $out/share/pydf
    install -t $out/share/pydf -m 444 pydfrc
    install -t $out/share/man/man1 -m 444 pydf.1
  '';

  meta = with lib; {
    description = "colourised df(1)-clone";
    homepage = "http://kassiopeia.juls.savba.sk/~garabik/software/pydf/";
    mainProgram = "pydf";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ monsieurp ];
  };
}
