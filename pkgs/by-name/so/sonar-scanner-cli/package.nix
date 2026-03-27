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
  version = "7.3.0.5189";

  src = fetchFromGitHub {
    owner = "SonarSource";
    repo = "sonar-scanner-cli";
    tag = version;
    hash = "sha256-Vbd+vQKFQo/wzGF4ekcCiEczlyuTD41Liz+nePR9lVA=";
  };

  mvnHash = "sha256-1SPpGu6uQ1Xa0U/DUjfZAXi6SQN/8LImU6THv4e9CSo=";

  mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

  nativeBuildInputs = [
    # For bsdtar (name is a misnomer since it handles multiple archive formats) to extract nested directories from .zip files.
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
  };
}
