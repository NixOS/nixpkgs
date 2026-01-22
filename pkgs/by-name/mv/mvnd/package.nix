{
  lib,
  fetchFromGitHub,
  graalvmPackages,
  installShellFiles,
  makeWrapper,
  maven,
  mvnd,
  nix-update-script,
  runCommand,
  stdenv,
  testers,
}:

let
  platformMap = {
    aarch64-darwin = "darwin-aarch64";
    aarch64-linux = "linux-aarch64";
    x86_64-darwin = "darwin-amd64";
    x86_64-linux = "linux-amd64";
  };
  inherit (platformMap.${stdenv.system}) os arch;
in

maven.buildMavenPackage rec {
  pname = "mvnd";
  version = "1.0.3";
  src = fetchFromGitHub {
    owner = "apache";
    repo = "maven-mvnd";
    rev = version;
    sha256 = "sha256-vlJG2uDY93iri1X7SYPRufAIN4fhAjCd8gCeCdz/QDE=";
  };

  # need graalvm at build-time for the `native-image` tool
  mvnJdk = graalvmPackages.graalvm-ce;
  mvnHash = "sha256-n6ZKEXDzyzMfUZt3WHkwCDB68gm30UGrFecffFy7ytA=";

  nativeBuildInputs = [
    graalvmPackages.graalvm-ce
    installShellFiles
    makeWrapper
  ];

  mvnDepsParameters = mvnParameters;
  mvnParameters = lib.concatStringsSep " " (
    [
      "-Dmaven.buildNumber.skip=true" # skip build number generation; requires a git repository
      "-Drat.skip=true" # skip license checks; they require manaul approval and should have already been run upstream
      "-Dspotless.skip=true" # skip formatting checks

      # skip tests that fail in the sandbox
      "-pl"
      "!integration-tests"
      "-Dtest=!org.mvndaemon.mvnd.client.OsUtilsTest,!org.mvndaemon.mvnd.cache.impl.CacheFactoryTest,!org.mvndaemon.mvnd.client.NoDaemonTest"
      "-Dsurefire.failIfNoSpecifiedTests=false"

      "-Pnative"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # see `buildGraalvmNativeImage`
      "-DbuildArgs=-H:-CheckToolchain"
    ]
  );

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/mvnd-home

    cp -r dist/target/maven-mvnd-${version}-${platformMap.${stdenv.system}}/* $out/mvnd-home
    makeWrapper $out/mvnd-home/bin/mvnd $out/bin/mvnd \
      --set-default MVND_HOME $out/mvnd-home

    installShellCompletion --cmd mvnd \
      --bash $out/mvnd-home/bin/mvnd-bash-completion.bash

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  }
  // (lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
    tests.version = testers.testVersion {
      # `java` or `JAVA_HOME` is required to run mvnd
      # presumably the user already has a JDK installed if they're using maven; don't pull in an unnecessary runtime dependency
      package =
        runCommand "mvnd"
          {
            inherit version;
            nativeBuildInputs = [ makeWrapper ];
          }
          ''
            mkdir -p $out/bin
            makeWrapper ${mvnd}/bin/mvnd $out/bin/mvnd \
              --suffix PATH : ${lib.makeBinPath [ mvnJdk ]}
          '';
    };
  });

  meta = {
    description = "Apache Maven Daemon";
    homepage = "https://maven.apache.org/";
    license = lib.licenses.asl20;
    platforms = builtins.attrNames platformMap;
    maintainers = with lib.maintainers; [ nathanregner ];
    mainProgram = "mvnd";
  };
}
