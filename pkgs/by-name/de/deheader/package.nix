{
  lib,
  stdenv,
  python3,
  xmlto,
  docbook-xsl-nons,
  fetchFromGitLab,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "deheader";
  version = "1.11";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitLab {
    owner = "esr";
    repo = "deheader";
    rev = version;
    hash = "sha256-RaWU6075PvgxbsH1+Lt/CEDAcl9Vx6kxcZAA/A/Af4o=";
  };

  buildInputs = [ python3 ];

  nativeBuildInputs = [
    xmlto
    docbook-xsl-nons
    installShellFiles
  ];

  # With upstream Makefile, xmlto is called without "--skip-validation". It
  # makes it require a lot of dependencies, yet ultimately it fails
  # nevertheless in attempt to fetch something from SourceForge.
  #
  # Need to set "foundMakefile" so "make check" tests are run.
  buildPhase = ''
    runHook preBuild

    xmlto man --skip-validation deheader.xml
    patchShebangs ./deheader
    foundMakefile=1

    runHook postBuild
  '';

  doCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ./deheader -t $out/bin
    installManPage ./deheader.1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to find and optionally remove unneeded includes in C or C++ source files";
    mainProgram = "deheader";
    longDescription = ''
      This tool takes a list of C or C++ sourcefiles and generates a report
      on which #includes can be omitted from them -- the test, for each foo.c
      or foo.cc or foo.cpp, is simply whether 'rm foo.o; make foo.o' returns a
      zero status. Optionally, with the -r option, the unneeded headers are removed.
      The tool also reports on headers required for strict portability.
    '';
    homepage = "http://catb.org/~esr/deheader";
    changelog = "https://gitlab.com/esr/deheader/-/blob/master/NEWS.adoc";
    license = licenses.bsd2;
    maintainers = with maintainers; [ kaction ];

    platforms = platforms.linux;
  };
}
