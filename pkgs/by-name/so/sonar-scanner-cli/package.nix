{
  lib,
  coreutils,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
  nix-update-script,
  unzip,
  which,
}:

maven.buildMavenPackage {
  pname = "sonar-scanner-cli";
  version = "6.1.0.4477";

  src = fetchFromGitHub {
    owner = "SonarSource";
    repo = "sonar-scanner-cli";
    rev = "1497fc93fc16630c69ccdf103d5e40926c4b581e";
    hash = "sha256-RyuM1xzJD3PZV1EbAjmIZ7jIM9vPr7rORzGXa5IIdjk=";
  };

  mvnHash = "sha256-7kyY4S02NScQ9cRupxunB0JI7Z62c5nJMoHtcQkqfb4=";

  mvnParameters = toString [ "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z" ];

  nativeBuildInputs = [
    coreutils
    makeWrapper
    unzip
  ];

  doCheck = false;

  installPhase = ''
    mkdir $out

    MAVEN_PROJECT_VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:3.4.1:evaluate -Dmaven.repo.local=.m2 -Dexpression=project.version -DforceStdout --quiet)

    unzip target/sonar-scanner-''${MAVEN_PROJECT_VERSION}.zip -d target

    mv target/sonar-scanner-''${MAVEN_PROJECT_VERSION}/* $out

    wrapProgram $out/bin/sonar-scanner \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          jre
          which
        ]
      } \
      --set JAVA_HOME ${jre}

    wrapProgram $out/bin/sonar-scanner-debug \
      --prefix PATH : ${lib.makeBinPath [ coreutils ]}
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Scanner CLI for SonarQube and SonarCloud";
    homepage = "https://github.com/SonarSource/sonar-scanner-cli";
    license = licenses.lgpl3Only;
    mainProgram = "sonar-scanner";
    platforms = platforms.all;
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
