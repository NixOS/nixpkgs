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
  version = "7.0.2";

  src = fetchFromGitHub {
    owner = "schemaspy";
    repo = "schemaspy";
    tag = "v${version}";
    hash = "sha256-X85Yv6yx1Hpl3vNDHtv6u38Err668dkAx1lqpoGnALg=";
  };

  mvnParameters = "-Dmaven.test.skip=true -Dmaven.buildNumber.skip=true";
  mvnHash = "sha256-sCVWNzh8m3KvJyYzE2Mn+gbJTSt1/yX44dE4s7HkygU=";

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
