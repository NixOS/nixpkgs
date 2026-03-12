{
  lib,
  makeWrapper,
  python3,
  nixosTests,
  maven,
  fetchFromGitHub,
  jdk,
  nix-update-script,
  xmlstarlet,
}:

# Skip some plugins not required for NixOS packaging to reduce required dependencies.
# Also skip the integration tests because they don't work in the sandbox.
let
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

  parameters = lib.concatStringsSep " " [
    projectFilter
    timestampParameter
  ];
in
maven.buildMavenPackage rec {
  pname = "nzbhydra2";
  version = "8.5.1";

  src = fetchFromGitHub {
    owner = "theotherp";
    repo = "nzbhydra2";
    tag = "v${version}";
    hash = "sha256-idLki0UB8uqtRUvxzwvJuJJyG3+EUUJ5D4Ui41YbMPw=";
  };

  mvnHash = "sha256-dodZT40zNqfaPd8VxfNYY10VrFNlL4xESDdTrgcFaaY=";

  mvnFetchExtraArgs.preBuild = ''
    mvn -nsu "${timestampParameter}" --projects org.nzbhydra:github-release-plugin "-Dmaven.repo.local=$out/.m2" clean install
  '';

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

  installPhase = ''
    runHook preInstall

    install -d -m 755 "$out/lib/${pname}/lib"
    cp -rt "$out/lib/${pname}/lib" core/target/*-exec.jar
    touch "$out/lib/${pname}/readme.md"
    install -D -m 755 "other/wrapper/nzbhydra2wrapperPy3.py" "$out/lib/nzbhydra2/nzbhydra2wrapperPy3.py"

    makeWrapper ${lib.getExe python3} "$out/bin/nzbhydra2" \
      --add-flags "$out/lib/nzbhydra2/nzbhydra2wrapperPy3.py" \
      --prefix PATH ":" ${lib.getBin jdk}/bin

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) nzbhydra2;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Usenet meta search";
    homepage = "https://github.com/theotherp/nzbhydra2";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      matteopacini
      tmarkus
    ];
    platforms = lib.platforms.linux;
    mainProgram = "nzbhydra2";
  };
}
