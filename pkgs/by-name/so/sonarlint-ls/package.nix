{
  lib,
  fetchFromGitHub,
  jre_headless,
  maven,
  jdk17,
  makeWrapper,
  writeShellApplication,
  curl,
  pcre,
  common-updater-scripts,
  jq,
  gnused,
  versionCheckHook,
}:

maven.buildMavenPackage rec {
  pname = "sonarlint-ls";
  version = "3.25.0.76263";

  src = fetchFromGitHub {
    owner = "SonarSource";
    repo = "sonarlint-language-server";
    rev = version;
    hash = "sha256-bnR6h2NRdGwmx04ydQIlE2VMe/C23YRqNxdbbb19yzE=";
  };

  mvnJdk = jdk17;
  mvnHash = "sha256-cRDrd2QysN3KCndfdnTn8/hXuJ1xd28GcE8vrd6ILuM=";

  # Disables failing tests which either need network access or are flaky.
  mvnParameters = lib.escapeShellArgs [
    "-Dskip.installnodenpm=true"
    "-Dskip.npm"
    "-Dtest=!LanguageServerMediumTests,
    !LanguageServerWithFoldersMediumTests,
    !NotebookMediumTests,
    !ConnectedModeMediumTests,
    !JavaMediumTests,
    !OpenNotebooksCacheTests"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/plugins}
    install -Dm644 target/sonarlint-language-server-*.jar $out/share/sonarlint-ls.jar
    install -Dm644 target/plugins/* $out/share/plugins

    makeWrapper ${jre_headless}/bin/java $out/bin/sonarlint-ls \
      --add-flags "-jar $out/share/sonarlint-ls.jar" \
      --add-flags "-analyzers $(ls -1 $out/share/plugins | tr '\n' ' ')"

    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  preVersionCheck = "export version=${lib.versions.majorMinor version}";
  versionCheckProgramArg = "-V";

  passthru.updateScript =
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

  meta = {
    description = "Sonarlint language server";
    mainProgram = "sonarlint-ls";
    homepage = "https://github.com/SonarSource/sonarlint-language-server";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ tricktron ];
  };
}
