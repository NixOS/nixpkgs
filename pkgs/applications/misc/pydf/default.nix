{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonPackage rec {
  pname = "pydf";
  version = "12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f0enw6v86xrAT8AJ3tU43xrkScMSA5YqFHGk6zvyFDk=";
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
