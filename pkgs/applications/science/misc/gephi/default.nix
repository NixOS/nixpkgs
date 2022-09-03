{ lib, stdenv, fetchFromGitHub, jdk, maven, javaPackages }:

let
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "gephi";
    repo = "gephi";
    rev = "v${version}";
    sha256 = "sha256-3+tOwcE7TUeexJCugFsx9SgsKeb7ApNqbMEIi9QaKPE=";
  };

  # perform fake build to make a fixed-output derivation out of the files downloaded from maven central (120MB)
  deps = stdenv.mkDerivation {
    name = "gephi-${version}-deps";
    inherit src;
    buildInputs = [ jdk maven ];
    buildPhase = ''
      while mvn package -Dmaven.repo.local=$out/.m2 -Dmaven.wagon.rto=5000; [ $? = 1 ]; do
        echo "timeout, restart maven to continue downloading"
      done
    '';
    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''find $out/.m2 -type f -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' -delete'';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-kIPsZN0alRAgiMbckQnMWKOKtCZ37D/6MgT17VYcr+s=";
  };
in
stdenv.mkDerivation {
  pname = "gephi";
  inherit version;

  inherit src;

  buildInputs = [ jdk maven ];

  buildPhase = ''
    # 'maven.repo.local' must be writable so copy it out of nix store
    mvn package --offline -Dmaven.repo.local=$(cp -dpR ${deps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2
  '';

  installPhase = ''
    cp -r modules/application/target/gephi $out

    # remove garbage
    find $out -type f -name  .lastModified -delete
    find $out -type f -regex '.+\.exe'     -delete

    # use self-compiled JOGL to avoid patchelf'ing .so inside jars
    rm $out/gephi/modules/ext/org.gephi.visualization/org-jogamp-{jogl,gluegen}/*.jar
    cp ${javaPackages.jogl_2_3_2}/share/java/jogl*.jar $out/gephi/modules/ext/org.gephi.visualization/org-jogamp-jogl/
    cp ${javaPackages.jogl_2_3_2}/share/java/glue*.jar $out/gephi/modules/ext/org.gephi.visualization/org-jogamp-gluegen/

    echo "jdkhome=${jdk}" >> $out/etc/gephi.conf
  '';

  meta = with lib; {
    description = "A platform for visualizing and manipulating large graphs";
    homepage = "https://gephi.org";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.gpl3;
    maintainers = [ maintainers.taeer ];
    platforms = [ "x86_64-linux" ];
  };
}
