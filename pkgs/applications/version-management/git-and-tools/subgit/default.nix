{ stdenv, fetchurl, unzip, makeWrapper, jre }:

stdenv.mkDerivation {
  name = "subgit-3.1.0";

  meta = {
    description = "A tool for a smooth, stress-free SVN to Git migration";
    longDescription = "Create writable Git mirror of a local or remote Subversion repository and use both Subversion and Git as long as you like. You may also do a fast one-time import from Subversion to Git.";
    homepage = http://subgit.com;
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.all;
  };

  buildInputs = [ unzip makeWrapper ];

  installPhase = ''
    mkdir $out;
    cp -r bin lib $out;
    wrapProgram $out/bin/subgit --set JAVA_HOME ${jre};
  '';

  src = fetchurl {
    url = http://old.subgit.com/download/subgit-3.1.0.zip;
    sha256 = "08qhpg6y2ziwplm0z1ghh1wfp607sw4hyb53a7qzfn759j5kcdrg";
  };
}