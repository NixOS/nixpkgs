{ lib, fetchFromGitHub, graalvm17-ce, maven, fetchurl }:
let
  mavenJdk17 = maven.override {
    jdk = graalvm17-ce;
  };
  metadataVersion = "0.3.4";
in
mavenJdk17.buildMavenPackage rec {
  pname = "httpx-cli";
  version = "v0.43.3";

  metadata = fetchurl {
    name = "graalvm-reachability-metadata.zip";
    url = "https://github.com/oracle/graalvm-reachability-metadata/releases/download/${metadataVersion}/graalvm-reachability-metadata-${metadataVersion}.zip";
    sha256 = "sha256-RJOwL95Mu4oVBt2pKyQjwcMoP3Bv05tVgXNnh92UHA8=";
  };

  src = fetchFromGitHub {
    owner = "servicex-sh";
    repo = "httpx";
    rev = "refs/tags/v${version}";
    hash = "sha256-dn0H9IrnlTi3O4qJ+yWZ3cKFdoKWtsUeW5wgg+F5FEs=";
  };

  preBuild = ''
    sed -i '/<metadataRepository>/,/<\/metadataRepository>/ s|<version>[0-9]\+\.[0-9]\+\.[0-9]\+</version>|<localPath>${metadata}</localPath>|g' pom.xml
  '';

  mvnParameters = "-DskipTests -Pnative";
  mvnHash = "sha256-HGufJSqg9fk2hvCYS+TN7yb2ZeKodSnO9tjvBfjkhSY=";

  installPhase = ''
    runHook preInstall

    install -Dm555 target/httpx $out/bin/httpx-cli/httpx-cli

    runHook postInstall
  '';

  meta = with lib; {
    description = "httpx is a CLI to execute requests from JetBrains Http File";
    homepage = "https://github.com/servicex-sh/httpx";
    license = licenses.apsl20;
    mainProgram = "httpx-cli";
    maintainers = with maintainers; [ ghostbuster91 ];
    inherit (graalvm17-ce.meta) platforms;
  };
}
