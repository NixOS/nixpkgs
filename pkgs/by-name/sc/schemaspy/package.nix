{
  lib,
  fetchFromGitHub,
  graphviz,
  jre,
  makeWrapper,
  maven,
  nix-update-script,
}:

maven.buildMavenPackage rec {
  pname = "schemaspy";
  version = "6.2.4";

  src = fetchFromGitHub {
    owner = "schemaspy";
    repo = "schemaspy";
    rev = "refs/tags/v${version}";
    hash = "sha256-yEqhLpGrJ4hki8o+u+bigVXv+3YvEb8TvHDTYsEl8z4=";
  };

  mvnParameters = "-Dmaven.test.skip=true -Dmaven.buildNumber.skip=true";
  mvnHash = "sha256-LCPRiY/DDSUnLGnaFUS9PPKnh3TmSyAOqKfEKRLRjpg=";

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -D target/${pname}-${version}-app.jar $out/share/java/${pname}-${version}.jar

    makeWrapper ${jre}/bin/java $out/bin/schemaspy \
      --add-flags "-jar $out/share/java/${pname}-${version}.jar" \
      --prefix PATH : ${lib.makeBinPath [ graphviz ]}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://schemaspy.org";
    description = "Document your database simply and easily";
    mainProgram = "schemaspy";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      jraygauthier
      anthonyroussel
    ];
  };
}
