{
  lib,
  perlPackages,
  fetchFromGitHub,
  makeWrapper,
  openssh,
}:

perlPackages.buildPerlPackage {
  pname = "ham-unstable";
  version = "2025-02-25";

  src = fetchFromGitHub {
    owner = "kernkonzept";
    repo = "ham";
    rev = "81b6f05fd91865c7d42b94a683388504489356dc";
    hash = "sha256-a1JaUD/jrF7Yf+vyUoKQFjojxenmsCVw3Uo8u7RjPiQ=";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [
    makeWrapper
  ];
  buildInputs = with perlPackages; [
    GitRepository
    URI
    XMLParser
  ];
  propagatedBuildInputs = [
    openssh
  ];

  preConfigure = ''
    rm -f Makefile
    touch Makefile.PL
    patchShebangs .
  '';

  installPhase = ''
    mkdir -p $out/lib $out/bin
    cp -r . $out/lib/ham

    makeWrapper $out/lib/ham/ham $out/bin/ham --argv0 ham \
      --prefix PATH : ${openssh}/bin
  '';

  meta = with lib; {
    description = "Tool to manage big projects consisting of multiple loosely-coupled git repositories";
    homepage = "https://github.com/kernkonzept/ham";
    license = licenses.bsd2;
    maintainers = with maintainers; [ aw ];
    mainProgram = "ham";
    platforms = platforms.unix;
  };
}
