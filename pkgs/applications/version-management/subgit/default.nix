{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation rec {
  pname = "subgit";
  version = "3.3.17";

  meta = {
    description = "A tool for a smooth, stress-free SVN to Git migration";
    longDescription = "Create writable Git mirror of a local or remote Subversion repository and use both Subversion and Git as long as you like. You may also do a fast one-time import from Subversion to Git.";
    homepage = "https://subgit.com";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  installPhase = ''
    mkdir $out;
    cp -r bin lib $out;
    wrapProgram $out/bin/subgit --set JAVA_HOME ${jre};
  '';

  src = fetchurl {
    url = "https://subgit.com/download/subgit-${version}.zip";
    sha256 = "sha256-u8YhaF4zOlDpEYd/0VUN8k4X8E1G4PB+UkJjBfQKkJY=";
  };
}
