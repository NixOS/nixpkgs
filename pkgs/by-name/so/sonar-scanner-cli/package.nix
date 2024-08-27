{
  lib,
  coreutils,
  fetchFromGitHub,
  jre,
  libarchive,
  makeWrapper,
  maven,
  nix-update-script,
}:

maven.buildMavenPackage rec {
  pname = "sonar-scanner-cli";
  version = "6.2.0.4584";

  src = fetchFromGitHub {
    owner = "SonarSource";
    repo = "sonar-scanner-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-T7Vx87TjLMUWLYkKKu1pZfXvR3LI+rmTfVeuvEz0qeM=";
  };

  mvnHash = "sha256-IKwpTUEE+WHl4WLkxyGvBmHo5tF9dvhkFobIZ8VAtv4=";

  mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

  nativeBuildInputs = [
    libarchive
    makeWrapper
  ];

  doCheck = false;

  # The .zip file with the programs is placed at "target/sonar-scanner-{project.version}.zip".
  #
  # To compute this .zip file path directly, we need to get the project version from the project's pom.xml.
  #
  # Parsing pom.xml is unsafe because project versions can be set dynamically. We need to use maven-help-plugin to get the evaluated value instead.
  #
  # Network isolation, however, prevents Maven from downloading packages in our shell script so we can't do this:
  #
  #   MAVEN_PROJECT_VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:3.4.1:evaluate \
  #     -Dmaven.repo.local=.m2 \
  #     -Dexpression=project.version \
  #     -DforceStdout \
  #     --quiet)
  #
  # We'll use wildcard expansion instead to find (what should be) the only .zip file in the "target" directory.
  installPhase = ''
    mkdir $out

    FILES=(target/sonar-scanner-*.zip)
    bsdtar --extract --file ''${FILES[0]} --strip-components 1 --directory $out

    wrapProgram $out/bin/sonar-scanner \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          jre
        ]
      } \
      --set JAVA_HOME ${jre}

    wrapProgram $out/bin/sonar-scanner-debug \
      --prefix PATH : ${lib.makeBinPath [ coreutils ]}
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Scanner CLI for SonarQube and SonarCloud";
    homepage = "https://github.com/SonarSource/sonar-scanner-cli";
    license = lib.licenses.lgpl3Only;
    mainProgram = "sonar-scanner";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ peterromfeldhk ];
  };
}
