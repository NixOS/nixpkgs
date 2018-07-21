{ stdenv, fetchurl }:
{ version, artifactId, groupId, sha512, type ? "jar", suffix ? "" }:

let
  name = "${artifactId}-${version}";
  m2Path = "${builtins.replaceStrings ["."] ["/"] groupId}/${artifactId}/${version}";
  m2File = "${name}${suffix}.${type}";
  src = fetchurl rec {
      inherit sha512;
      urls = [
        "https://repo.clojars.org/${m2Path}/${m2File}"
        "https://repo1.maven.org/maven2/${m2Path}/${m2File}"
      ];
  };
in stdenv.mkDerivation rec {
  inherit name m2Path m2File src;

  installPhase = ''
    mkdir -p $out/.m2/$m2Path
    cp $src $out/.m2/$m2Path/$m2File
  '';

  phases = "installPhase";
}
