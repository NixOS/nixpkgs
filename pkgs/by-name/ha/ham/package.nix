{
  lib,
  perlPackages,
  fetchFromGitHub,
  makeWrapper,
  openssh,
}:

perlPackages.buildPerlPackage {
  pname = "ham-unstable";
  version = "2025-11-12";

  src = fetchFromGitHub {
    owner = "kernkonzept";
    repo = "ham";
    rev = "11c8b146f8b11e7f284050fe205ae8afb1715541";
    hash = "sha256-SlraTVE03UEF5Spjy6ZEPbhS/INBR/9MaRLw4/AxZds=";
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

  meta = {
    description = "Tool to manage big projects consisting of multiple loosely-coupled git repositories";
    homepage = "https://github.com/kernkonzept/ham";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ aw ];
    mainProgram = "ham";
    platforms = lib.platforms.unix;
  };
}
