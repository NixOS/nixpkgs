{
  lib,
  fetchFromGitHub,
  makeWrapper,
  jdk_headless,
  jre_minimal,
  maven,
  writeShellApplication,
  curl,
  pcre,
  common-updater-scripts,
  jq,
  gnused,
}:

let
  jre = jre_minimal.override {
    modules = [
      "java.base"
      "java.logging"
      "java.xml"
    ];
    jdk = jdk_headless;
  };
in
maven.buildMavenPackage rec {
  pname = "lemminx";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "lemminx";
    tag = version;
    hash = "sha256-a+9RN1265fsmYAUMuUTxA+VqJv7xPlzuc8HqoZwmR4M=";
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

  mvnJdk = jdk_headless;
  mvnHash = "sha256-0KnaXr5Mmwm0pV4o5bAX0MWKl6f/cvlO6cyV9UcgXeo=";

  # Disable gitcommitid plugin which needs a .git folder which we don't have.
  # Disable failing tests which either need internet access or are flaky.
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
    !DTDValidationExternalResourcesTest,
    !DTDHoverExtensionsTest,
    !CacheResourcesManagerTest"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    install -Dm644 org.eclipse.lemminx/target/org.eclipse.lemminx-uber.jar $out/share

    makeWrapper ${jre}/bin/java $out/bin/lemminx \
      --add-flags "-jar $out/share/org.eclipse.lemminx-uber.jar"

    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];

  passthru = {
    updateScript =
      let
        pkgFile = toString ./package.nix;
      in
      lib.getExe (writeShellApplication {
        name = "update-${pname}";
        runtimeInputs = [
          curl
          pcre
          common-updater-scripts
          jq
          gnused
        ];
        text = ''
          if [ -z "''${GITHUB_TOKEN:-}" ]; then
              echo "no GITHUB_TOKEN provided - you could meet API request limiting" >&2
          fi

          LATEST_TAG=$(curl -H "Accept: application/vnd.github+json" \
            ''${GITHUB_TOKEN:+-H "Authorization: bearer $GITHUB_TOKEN"} \
            -Lsf https://api.github.com/repos/${src.owner}/${src.repo}/tags | \
            jq -r '[.[] | select(.name | test("^[0-9]"))] | sort_by(.name | split(".") |
            map(tonumber)) | reverse | .[0].name')
          update-source-version ${pname} "$LATEST_TAG"
          sed -i '0,/mvnHash *= *"[^"]*"/{s/mvnHash = "[^"]*"/mvnHash = ""/}' ${pkgFile}

          echo -e "\nFetching all mvn dependencies to calculate the mvnHash. This may take a while ..."
          nix-build -A ${pname}.fetchedMavenDeps 2> ${pname}-stderr.log || true

          NEW_MVN_HASH=$(grep "got:" ${pname}-stderr.log | awk '{print ''$2}')
          rm ${pname}-stderr.log
          # escaping double quotes looks ugly but is needed for variable substitution
          # use # instead of / as separator because the sha256 might contain the / character
          sed -i "0,/mvnHash *= *\"[^\"]*\"/{s#mvnHash = \"[^\"]*\"#mvnHash = \"$NEW_MVN_HASH\"#}" ${pkgFile}
        '';
      });
  };

  meta = with lib; {
    description = "XML Language Server";
    mainProgram = "lemminx";
    homepage = "https://github.com/eclipse/lemminx";
    license = licenses.epl20;
    maintainers = with maintainers; [ tricktron ];
  };
}
