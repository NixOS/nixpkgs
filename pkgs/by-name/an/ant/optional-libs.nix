# Libraries needed to compile Ant's optional tasks.
#
# Upstream's build.sh only bundles junit and hamcrest into lib/optional;
# every other optional library is fetched from Maven Central by
# fetch.xml.  Without them Ant compiles no classes for the affected
# optional tasks and ships stub jars, which breaks consumers that use
# those tasks (e.g. jogl needs the antlr task).
#
# Mirrors upstream's fetch.xml.  Deliberately not fetched: JAI
# (javax.media:jai-core / com.sun.media:jai-codec live only in the
# JBoss repository, not Maven Central) - the stub jars for those
# tasks remain empty, but no nixpkgs package uses them.
{
  fetchMavenArtifact,
}:

let
  central = [ "https://repo1.maven.org/maven2" ];
in
map (args: fetchMavenArtifact (args // { repos = central; })) [
  {
    groupId = "antlr";
    artifactId = "antlr";
    version = "2.7.7";
    hash = "sha256-iPvaS5Ellrn1bo4S5YDMlUus+1F3bs/d0+GPwc9W3Ew=";
  }
  {
    groupId = "org.apache.bcel";
    artifactId = "bcel";
    version = "6.12.0";
    hash = "sha256-ASY549KjB59MnBNQ8YICzqg6cRLvIQ5QyTsLdxrV068=";
  }
  {
    groupId = "bsf";
    artifactId = "bsf";
    version = "2.4.0";
    hash = "sha256-+HN3PeuRwaHBIVD2zbE7ii4bSWp1rJA8S7+hA7Njp8c=";
  }
  {
    groupId = "com.sun.activation";
    artifactId = "jakarta.activation";
    version = "2.0.1";
    hash = "sha256-ueJLfdbgdJVWLqllMb4xMMltuk144d/Yitu96/QzKHE=";
  }
  {
    groupId = "javax.activation";
    artifactId = "activation";
    version = "1.1.1";
    hash = "sha256-rkdRIOn82ZtLALODKb1hzcXrdU7uA/5mwB9Q4TdyT5k=";
  }
  {
    groupId = "commons-logging";
    artifactId = "commons-logging-api";
    version = "1.1";
    hash = "sha256-M6TdR7tHZOTrNpLYY4bReg2YJ/T0uw9wEh76trwDujU=";
  }
  {
    groupId = "commons-net";
    artifactId = "commons-net";
    version = "3.13.0";
    hash = "sha256-nohESvrclGfwvz0yj5O5U42jWpvgXN7kMHZuZP3b1sU=";
  }
  {
    groupId = "jakarta-regexp";
    artifactId = "jakarta-regexp";
    version = "1.4";
    hash = "sha256-heo5hdf+xVLW3m8C2OGHicP81TkIHrjHxETqv2yz97w=";
  }
  {
    groupId = "com.sun.mail";
    artifactId = "jakarta.mail";
    version = "2.0.2";
    hash = "sha256-U28K5d13TiV/MGTxmiuYKqVgcsB8Z1xw+YzcJiBHtLU=";
  }
  {
    groupId = "com.sun.mail";
    artifactId = "javax.mail";
    version = "1.6.2";
    hash = "sha256-RbUV5xBJRMCeRbnHuxzl3/ZASGN0hS3SsugMw3Ut+hE=";
  }
  {
    groupId = "jdepend";
    artifactId = "jdepend";
    version = "2.9.1";
    hash = "sha256-uBBXib1El4NrzsJj1aEtYybU63tP44U10XnkpE3oM3A=";
  }
  {
    groupId = "com.jcraft";
    artifactId = "jsch";
    version = "0.1.55";
    hash = "sha256-1JKxWm0uo/HMOcQiyVPEDBIokHPb6DYNmMD2+ex0/EQ=";
  }
  {
    groupId = "log4j";
    artifactId = "log4j";
    version = "1.2.14";
    hash = "sha256-47/5q2SgmxrCgA87X7Hj2ZcoBkrLbdOSSThQdjikBPs=";
  }
  {
    groupId = "oro";
    artifactId = "oro";
    version = "2.0.8";
    hash = "sha256-4AzNrV3360P97kQjLvZGAr9jgHwtEzp76Dugn9Sa8m4=";
  }
  {
    groupId = "xalan";
    artifactId = "serializer";
    version = "2.7.3";
    hash = "sha256-X2gEus39s8zFLSU4U2+riYZpbWFVmwgQVKQgxlOAZmc=";
  }
  {
    groupId = "xalan";
    artifactId = "xalan";
    version = "2.7.3";
    hash = "sha256-/r1IuxM6lsRHKCITlRprdOp/tFwNiWEhKWwBQxa9prA=";
  }
  {
    groupId = "xml-resolver";
    artifactId = "xml-resolver";
    version = "1.2";
    hash = "sha256-R9zeiYYBkxTveK5ygKlJc6IdLtlQdaQKAAtC2pVkKeE=";
  }
  {
    groupId = "org.tukaani";
    artifactId = "xz";
    version = "1.9";
    hash = "sha256-IRswbPxE+Plt86Cj3a91uoxSie7XfWDXL4ibuFX1NeU=";
  }
]
