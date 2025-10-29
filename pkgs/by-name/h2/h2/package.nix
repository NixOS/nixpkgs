{
  fetchFromGitHub,
  jre,
  lib,
  makeWrapper,
  maven,
  nix-update-script,
}:

maven.buildMavenPackage rec {
  pname = "h2";
  version = "2.4.240";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "h2database";
    repo = "h2database";
    tag = "version-${version}";
    hash = "sha256-Cy6MoumJBhhcYT6dCHWeOfmhjGRkdNvSONdIiZaf6uU=";
  };

  mvnParameters = "-f h2/pom.xml";
  mvnHash = "sha256-ue1X0fswi3C9uqJ/cVCf/qd2XStMve1k1qA+IsREOGk=";

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  installPhase = ''
    mkdir -p $out/share/java
    install -Dm644 h2/target/h2-${version}.jar $out/share/java

    makeWrapper ${jre}/bin/java $out/bin/h2 \
      --add-flags "-cp \"$out/share/java/h2-${version}.jar:\$H2DRIVERS:\$CLASSPATH\" org.h2.tools.Console"

    mkdir -p $doc/share/doc/h2
    cp -r h2/src/docsrc/* $doc/share/doc/h2
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^version-([0-9.]+)$"
    ];
  };

  meta = {
    description = "Java SQL database";
    homepage = "https://h2database.com/html/main.html";
    changelog = "https://h2database.com/html/changelog.html";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      mahe
      anthonyroussel
    ];
    mainProgram = "h2";
  };
}
