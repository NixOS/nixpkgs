{
  lib,
  fetchFromGitHub,
  graphviz,
  jre,
  makeWrapper,
  maven,
  nix-update-script,
}:

maven.buildMavenPackage (finalAttrs: {
  pname = "schemaspy";
  version = "7.0.2";

  src = fetchFromGitHub {
    owner = "schemaspy";
    repo = "schemaspy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X85Yv6yx1Hpl3vNDHtv6u38Err668dkAx1lqpoGnALg=";
  };

  mvnParameters = "-Dmaven.test.skip=true -Dmaven.buildNumber.skip=true";
  mvnHash = "sha256-XMbStix0XAFwsnLM2g+nxNc/USUN0O7mqkHTQRjZG5c=";

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -D target/${finalAttrs.pname}-${finalAttrs.version}-app.jar $out/share/java/${finalAttrs.pname}-${finalAttrs.version}.jar

    makeWrapper ${jre}/bin/java $out/bin/schemaspy \
      --add-flags "-jar $out/share/java/${finalAttrs.pname}-${finalAttrs.version}.jar" \
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
})
