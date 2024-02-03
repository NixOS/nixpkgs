{ lib, fetchFromGitHub, jdk11, maven, javaPackages }:

let
  mavenJdk11 = maven.override {
    jdk = jdk11;
  };
in
mavenJdk11.buildMavenPackage rec {
  pname = "gephi";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "gephi";
    repo = "gephi";
    rev = "v${version}";
    hash = "sha256-ZNSEaiD32zFfF2ISKa1CmcT9Nq6r5i2rNHooQAcVbn4=";
  };

  mvnHash = "sha256-/2/Yb26Ry0NHQQ3j0LXnjwC0wQqJiztvTgWixyMJqvg=";

  nativeBuildInputs = [ jdk11 ];

  installPhase = ''
    cp -r modules/application/target/gephi $out

    # remove garbage
    find $out -type f -name  .lastModified -delete
    find $out -type f -regex '.+\.exe'     -delete

    # use self-compiled JOGL to avoid patchelf'ing .so inside jars
    rm $out/gephi/modules/ext/org.gephi.visualization/org-jogamp-{jogl,gluegen}/*.jar
    cp ${javaPackages.jogl_2_4_0}/share/java/jogl*.jar $out/gephi/modules/ext/org.gephi.visualization/org-jogamp-jogl/
    cp ${javaPackages.jogl_2_4_0}/share/java/glue*.jar $out/gephi/modules/ext/org.gephi.visualization/org-jogamp-gluegen/

    printf "\n\njdkhome=${jdk11}\n" >> $out/etc/gephi.conf
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
  };
}
