{
  lib,
  biome,
  buildNpmPackage,
  fetchFromGitHub,
  jdk25,
  maven,
  makeWrapper,
  unzip,
  nixosTests,
  writeText,
}:
let
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "Athou";
    repo = "commafeed";
    tag = version;
    hash = "sha256-M5p3nzlEIuIEMADZyQUqE6WAzlMmP/e4Zh9J8nbhZ9Q=";
  };

  frontend = buildNpmPackage {
    inherit version src;

    pname = "commafeed-frontend";

    sourceRoot = "${src.name}/commafeed-client";

    npmDepsHash = "sha256-XkUlsRdqIXwVExvSofZJLKMUSzjxJRRpV549UTP9Cjo=";

    nativeBuildInputs = [ biome ];

    installPhase = ''
      runHook preInstall

      cp -r dist/ $out

      runHook postInstall
    '';
  };

  gitProperties = writeText "git.properties" ''
    git.branch = none
    git.build.time = 1970-01-01T00:00:00+0000
    git.build.version = ${version}
    git.commit.id = none
    git.commit.id.abbrev = none
  '';
in
maven.buildMavenPackage {
  inherit version src;

  pname = "commafeed";

  mvnHash = "sha256-vZ7BPA2N3jgRnTwF3k9En2Pn+zTrXbtB9FGbmU4wJgY=";
  mvnJdk = jdk25;

  mvnParameters = lib.escapeShellArgs [
    "-Dskip.installnodenpm"
    "-Dskip.npm"
    "-Dspotless.check.skip"
    "-Dmaven.gitcommitid.skip"
  ];

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  configurePhase = ''
    runHook preConfigure

    ln -sf "${frontend}" commafeed-client/dist

    cp ${gitProperties} commafeed-server/src/main/resources/git.properties

    runHook postConfigure
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    unzip -d $out/share/ commafeed-server/target/commafeed-$version-h2-jvm.zip

    makeWrapper ${jdk25}/bin/java $out/bin/commafeed \
      --add-flags "-jar $out/share/commafeed-$version-h2/quarkus-run.jar"

    runHook postInstall
  '';

  passthru.tests = nixosTests.commafeed;

  meta = {
    description = "Google Reader inspired self-hosted RSS reader";
    homepage = "https://github.com/Athou/commafeed";
    license = lib.licenses.asl20;
    mainProgram = "commafeed";
    maintainers = [ ];
  };
}
