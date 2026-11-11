{
  lib,
  makeWrapper,
  python3,
  nixosTests,
  maven,
  fetchFromGitHub,
  buildNpmPackage,
  jdk,
  nodejs_26,
  nix-update-script,
  xmlstarlet,
}:

let
  version = "9.1.1";

  src = fetchFromGitHub {
    owner = "theotherp";
    repo = "nzbhydra2";
    tag = "v${version}";
    hash = "sha256-z1qyT6B//skWFGKysvOauZcFAJyul6ouAL2uwSANFqk=";
  };

  # Skip some plugins not required for NixOS packaging to reduce required dependencies.
  # Also skip the integration tests because they don't work in the sandbox.
  projectFilter = "--projects ${
    lib.concatMapStringsSep "," (x: "!org.nzbhydra:${x}") [
      "github-release-plugin"
      "discordreleaser"
      "releases"
      "generic-release"
      "linux-amd64-release"
      "linux-arm64-release"
      "windows-release"
      "tests"
    ]
  },!org.nzbhydra.tests:system";

  timestampParameter = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

  # The UI is built by the `frontend` derivation; the exec plugin would run `npm ci`, which needs network access.
  parameters = lib.concatStringsSep " " [
    projectFilter
    timestampParameter
    "-Dexec.skip=true"
  ];

  frontend = buildNpmPackage {
    pname = "nzbhydra2-frontend";
    inherit version src;

    sourceRoot = "${src.name}/core/ui-react";

    nodejs = nodejs_26;

    npmDepsHash = "sha256-WwjJ6hDfl/aQWQ4yQNB+H6hD78k5iKuGB/rdqx7PQxk=";

    installPhase = ''
      runHook preInstall

      cp -r dist $out

      runHook postInstall
    '';
  };

  copyFrontend = ''
    mkdir -p core/target/classes/static
    cp -r ${frontend} core/target/classes/static/react
    chmod -R u+w core/target/classes/static/react
  '';
in
maven.buildMavenPackage {
  pname = "nzbhydra2";
  inherit version src;

  mvnHash = "sha256-J/yRwJIfonXFOMCuQAQyaDoggpAqSCQ90E0VNb8Cx0k=";

  # The fetch runs core's tests too, and WebConfigurationTest needs the UI bundle on the classpath.
  mvnFetchExtraArgs.preBuild = ''
    mvn -nsu "${timestampParameter}" --projects org.nzbhydra:github-release-plugin "-Dmaven.repo.local=$out/.m2" clean install
  ''
  + copyFrontend;

  mvnFetchExtraArgs.postInstall = ''
    ${lib.getExe xmlstarlet} ed -L -u "/metadata/versioning/lastUpdated" -v "0" $out/.m2/org/nzbhydra/github-release-plugin/maven-metadata-local.xml
  '';

  mvnJdk = jdk;

  doCheck = true;

  mvnDepsParameters = parameters;
  mvnParameters = parameters;

  nativeBuildInputs = [
    makeWrapper
  ];

  preBuild = copyFrontend;

  installPhase = ''
    runHook preInstall

    install -d -m 755 "$out/lib/nzbhydra2/lib"
    cp -rt "$out/lib/nzbhydra2/lib" core/target/*-exec.jar
    touch "$out/lib/nzbhydra2/readme.md"
    install -D -m 755 "other/wrapper/nzbhydra2wrapperPy3.py" "$out/lib/nzbhydra2/nzbhydra2wrapperPy3.py"

    makeWrapper ${lib.getExe python3} "$out/bin/nzbhydra2" \
      --add-flags "$out/lib/nzbhydra2/nzbhydra2wrapperPy3.py" \
      --prefix PATH ":" ${lib.getBin jdk}/bin

    runHook postInstall
  '';

  passthru = {
    inherit frontend;
    tests = {
      inherit (nixosTests) nzbhydra2;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
  };

  meta = {
    description = "Usenet meta search";
    homepage = "https://github.com/theotherp/nzbhydra2";
    changelog = "https://github.com/theotherp/nzbhydra2/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      matteopacini
      tmarkus
    ];
    platforms = lib.platforms.linux;
    mainProgram = "nzbhydra2";
  };
}
