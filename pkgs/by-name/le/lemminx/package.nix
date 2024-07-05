{ lib
, fetchFromGitHub
, makeWrapper
, jre_headless
, maven
, writeScript
, lemminx
}:

maven.buildMavenPackage rec {
  pname = "lemminx";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "lemminx";
    rev = version;
    hash = "sha256-VWYTkYlPziNRyxHdvIWVuDlABpKdzhC/F6BUBj/opks=";
    # Lemminx reads this git information at runtime from a git.properties
    # file on the classpath
    leaveDotGit = true;
    postFetch = ''
      cat > $out/org.eclipse.lemminx/src/main/resources/git.properties << EOF
      git.build.version=${version}
      git.commit.id.abbrev=$(git -C $out rev-parse --short HEAD)
      git.commit.message.short=$(git -C $out log -1 --pretty=format:%s)
      git.branch=main
      EOF
      rm -rf $out/.git
    '';
  };

  manualMvnArtifacts = [
    "org.apache.maven.surefire:surefire-junit-platform:3.1.2"
    "org.junit.platform:junit-platform-launcher:1.10.0"
  ];

  mvnHash = "sha256-LSnClLdAuqSyyT7O4f4aVaPBxdkkZQz60wTmqwQuzdU=";

  buildOffline = true;

  # disable gitcommitid plugin which needs a .git folder which we
  # don't have
  mvnDepsParameters = "-Dmaven.gitcommitid.skip=true";

  # disable failing tests which either need internet access or are flaky
  mvnParameters = lib.escapeShellArgs [
    "-Dmaven.gitcommitid.skip=true"
    "-Dtest=!XMLValidationCommandTest,
    !XMLValidationExternalResourcesBasedOnDTDTest,
    !XMLSchemaPublishDiagnosticsTest,
    !PlatformTest,
    !XMLValidationExternalResourcesBasedOnXSDTest,
    !XMLExternalTest,
    !XMLSchemaCompletionExtensionsTest,
    !XMLSchemaDiagnosticsTest,
    !MissingChildElementCodeActionTest,
    !XSDValidationExternalResourcesTest,
    !DocumentLifecycleParticipantTest,
    !DTDValidationExternalResourcesTest"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    install -Dm644 org.eclipse.lemminx/target/org.eclipse.lemminx-uber.jar \
      $out/share

    makeWrapper ${jre_headless}/bin/java $out/bin/lemminx \
      --add-flags "-jar $out/share/org.eclipse.lemminx-uber.jar"

    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];

  passthru.updateScript = writeScript "update-lemminx" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl pcre common-updater-scripts jq gnused
    set -eu -o pipefail

    LATEST_TAG=$(curl https://api.github.com/repos/eclipse/lemminx/tags | \
      jq -r '[.[] | select(.name | test("^[0-9]"))] | sort_by(.name | split(".") |
      map(tonumber)) | reverse | .[0].name')
    update-source-version lemminx "$LATEST_TAG"
    sed -i '0,/mvnHash *= *"[^"]*"/{s/mvnHash = "[^"]*"/mvnHash = ""/}' ${lemminx}

    echo -e "\nFetching all mvn dependencies to calculate the mvnHash. This may take a while ..."
    nix-build -A lemminx.fetchedMavenDeps 2> lemminx-stderr.log || true

    NEW_MVN_HASH=$(cat lemminx-stderr.log | grep "got:" | awk '{print ''$2}')
    rm lemminx-stderr.log
    # escaping double quotes looks ugly but is needed for variable substitution
    # use # instead of / as separator because the sha256 might contain the / character
    sed -i "0,/mvnHash *= *\"[^\"]*\"/{s#mvnHash = \"[^\"]*\"#mvnHash = \"$NEW_MVN_HASH\"#}" ${lemminx}
  '';

  meta = with lib; {
    description = "XML Language Server";
    mainProgram = "lemminx";
    homepage = "https://github.com/eclipse/lemminx";
    license = licenses.epl20;
    maintainers = with maintainers; [ tricktron ];
  };
}
