{
  lib,
  maven,
  fetchFromGitHub,
  jre,
  makeWrapper,
}:
maven.buildMavenPackage rec {
  pname = "apgdiff";
  version = "2.7.0";

  src = fetchFromGitHub {
    sparseCheckout = [ "src" ];
    owner = "fordfrog";
    repo = "apgdiff";
    rev = "refs/tags/release_${version}";
    hash = "sha256-2m+9QNwQV2tJwOabTXE2xjRB5gDrSwyL6zL2op+wmkM=";
  };

  # Fix wrong version string in --help
  postPatch = ''
    sed -i 's/VersionNumber=.*/VersionNumber=${version}/' \
      src/main/resources/cz/startnet/utils/pgdiff/Resources.properties
  '';

  mvnHash = "sha256-zJQirS8sVqHKZsBukEOf7ox5IeiAVOP6wEHWb4CAyxc=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm644 target/apgdiff-${version}.jar $out/lib/apgdiff.jar

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/apgdiff \
      --argv0 apgdiff \
      --add-flags "-jar $out/lib/apgdiff.jar"
  '';

  meta = with lib; {
    description = "Another PostgreSQL diff tool";
    mainProgram = "apgdiff";
    homepage = "https://apgdiff.com";
    license = licenses.mit;
    inherit (jre.meta) platforms;
    maintainers = [ maintainers.misterio77 ];
  };
}
