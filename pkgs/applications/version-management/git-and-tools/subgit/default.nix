{ stdenv, fetchurl, unzip, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "subgit-3.3.9";

  meta = {
    description = "A tool for a smooth, stress-free SVN to Git migration";
    longDescription = "Create writable Git mirror of a local or remote Subversion repository and use both Subversion and Git as long as you like. You may also do a fast one-time import from Subversion to Git.";
    homepage = http://subgit.com;
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.all;
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  installPhase = ''
    mkdir $out;
    cp -r bin lib $out;
    wrapProgram $out/bin/subgit --set JAVA_HOME ${jre};
  '';

  src = fetchurl {
    url = "https://subgit.com/download/${name}.zip";
    sha256 = "0dwd2kymmprci3b61ayr6axzlkc8zgbc40jqxvvyzschfxw9y0v5";
  };
}
