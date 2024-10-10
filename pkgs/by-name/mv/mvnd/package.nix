{
  darwin,
  fetchFromGitHub,
  graalvmCEPackages,
  installShellFiles,
  jdk,
  lib,
  makeWrapper,
  maven,
  mvnd,
  nix-update-script,
  stdenv,
  testers,
}:

assert jdk != null;

let
  platformMap = {
    aarch64-darwin = "darwin-aarch64";
    aarch64-linux = "linux-aarch64";
    x86_64-darwin = "darwin-amd64";
    x86_64-linux = "linux-amd64";
  };
in

maven.buildMavenPackage rec {
  pname = "mvnd";
  version = "1.0.2";
  src = fetchFromGitHub {
    owner = "apache";
    repo = "maven-mvnd";
    rev = version;
    fetchSubmodules = false;
    sha256 = "sha256-c1jD7m4cOdPWQEoaUMcNap2zvvX7H9VaWQv8JSgAnRU=";
  };

  mvnJdk = graalvmCEPackages.graalvm-ce;

  mvnHash = "sha256-Bx0XSnpHNxNX07uVPc18py9qbnG5b3b7J4vs44ty034=";

  nativeBuildInputs = [
    graalvmCEPackages.graalvm-ce
    installShellFiles
    makeWrapper
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Foundation ];

  mvnDepsParameters = mvnParameters;
  mvnParameters = lib.concatStringsSep " " [
    "-Dmaven.buildNumber.skip=true" # skip build number generation; requires a git repository
    "-Drat.skip=true" # skip license checks; they require manaul approval and should have already been run upstream
    "-Dspotless.skip=true" # skip formatting checks

    # skip tests that fail in the sandbox
    "-pl"
    "!integration-tests"
    "-Dtest=!org.mvndaemon.mvnd.client.OsUtilsTest,!org.mvndaemon.mvnd.cache.impl.CacheFactoryTest"
    "-Dsurefire.failIfNoSpecifiedTests=false"

    "-Pnative"
    # propagate linker args required by the darwin build
    # see `buildGraalvmNativeImage`
    ''-Dgraalvm-native-static-opt="-H:-CheckToolchain $(export -p | sed -n 's/^declare -x \([^=]\+\)=.*$/ -E\1/p' | tr -d \\n)"''
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/mvnd-home

    cp -r dist/target/maven-mvnd-${version}-${platformMap.${stdenv.system}}/* $out/mvnd-home
    makeWrapper $out/mvnd-home/bin/mvnd $out/bin/mvnd \
      --set-default JAVA_HOME "${jdk}" \
      --set-default MVND_HOME $out/mvnd-home

    installShellCompletion --cmd mvnd \
      --bash $out/mvnd-home/bin/mvnd-bash-completion.bash

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion { package = mvnd; };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "The Apache Maven Daemon";
    homepage = "https://maven.apache.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nathanregner ];
    mainProgram = "mvnd";
  };
}
