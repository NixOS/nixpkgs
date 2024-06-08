{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jre,
  maven,
  makeWrapper,
  nixosTests,
  writeText,
}:
let
  version = "4.3.3";

  src = fetchFromGitHub {
    owner = "Athou";
    repo = "commafeed";
    rev = version;
    hash = "sha256-y0gTmtlDg7sdunG1ne/3WkFx2KQkTGRlfYpXBHFFh2o=";
  };

  frontend = buildNpmPackage {
    inherit version src;

    pname = "commafeed-frontend";

    sourceRoot = "${src.name}/commafeed-client";

    npmDepsHash = "sha256-fye7MPWXUeFCMgcnesspd1giGG/ZldiOv00fjtXZSb4=";

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

  mvnHash = "sha256-YnEDJf4GeyiXxOh8tZZTZdLOJrisG6lmShXU97ueGNE=";

  mvnParameters = lib.escapeShellArgs [
    "-Dskip.installnodenpm"
    "-Dskip.npm"
    "-Dspotless.check.skip"
    "-Dmaven.gitcommitid.skip"
  ];

  nativeBuildInputs = [ makeWrapper ];

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
    install -Dm644 commafeed-server/target/commafeed.jar $out/share/commafeed.jar
    install -Dm644 commafeed-server/config.yml.example $out/share/config.yml

    makeWrapper ${jre}/bin/java $out/bin/commafeed \
      --add-flags "-jar $out/share/commafeed.jar"

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/share/config.yml \
      --replace-fail 'url: jdbc:h2:/commafeed/data/db;DEFRAG_ALWAYS=TRUE' \
        'url: jdbc:h2:./database/db;DEFRAG_ALWAYS=TRUE'
  '';

  passthru.tests = nixosTests.commafeed;

  meta = {
    description = "Google Reader inspired self-hosted RSS reader";
    homepage = "https://github.com/Athou/commafeed";
    license = lib.licenses.asl20;
    mainProgram = "commafeed";
    maintainers = [ lib.maintainers.raroh73 ];
  };
}
