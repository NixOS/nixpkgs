{ lib, stdenv, python3Packages, fetchFromGitHub, makeWrapper, xpdf, testers, pdfdiff }:

stdenv.mkDerivation rec {
  pname = "pdfdiff";
  version = "0.93";

  src = fetchFromGitHub {
    owner = "cascremers";
    repo = "pdfdiff";
    rev = version;
    sha256 = "sha256-NPki/PFm0b71Ksak1mimR4w6J2a0jBCbQDTMQR4uZFI=";
  };

  postPatch = ''
    sed -i -r 's|progName = "pdfdiff.py"|progName = "pdfdiff"|' pdfdiff.py
  '';

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;
  doCheck = false;

  installPhase = ''
    install -D -m 0755 pdfdiff.py $out/bin/pdfdiff
  '';

  postFixup = ''
    substituteInPlace $out/bin/pdfdiff --replace "#!/usr/bin/env python3" "#!${python3Packages.python.interpreter}"

    wrapProgram $out/bin/pdfdiff --prefix PATH : ${lib.makeBinPath [ xpdf ]}
  '';

  passthru.tests.version = testers.testVersion {
    package = pdfdiff;
    command = "pdfdiff --help";
  };

  meta = with lib; {
    homepage = "http://www.cs.ox.ac.uk/people/cas.cremers/misc/pdfdiff.html";
    description = "Tool to view the difference between two PDF or PS files";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
