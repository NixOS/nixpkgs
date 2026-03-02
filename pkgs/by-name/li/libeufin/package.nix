{
  lib,
  stdenv,
  fetchgit,
  python3,
  jdk17_headless,
  gradle_8,
  makeWrapper,
  postgresql,
  postgresqlTestHook,
}:
let
  customPython = python3.withPackages (p: [ p.setuptools ]);
  # "Deprecated Gradle features were used in this build, making it incompatible with Gradle 9.0."
  gradle = gradle_8;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libeufin";
  version = "1.3.0";

  src = fetchgit {
    url = "https://git.taler.net/libeufin.git/";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bt1NBoiN52CX2Itg8lQ/b0V/MZulBTaD8luNlH4Mwss=";
    fetchSubmodules = true;
    leaveDotGit = true; # required for correct submodule fetching
    # Save the HEAD short commit hash in a file so it can be retrieved later for versioning.
    # Delete .git folder for reproducibility (otherwise, the hash changes unexpectedly after fetching submodules)
    postFetch = ''
      pushd $out
      git rev-parse HEAD > ./libeufin-common/src/main/resources/HEAD.txt
      rm -rf .git
      popd
    '';
  };

  patchPhase = ''
    runHook prePatch

    substituteInPlace Makefile \
      --replace-fail "install: build install-nobuild-files" "install: install-nobuild-files"

    # The .git folder had to be deleted. Read hash from file instead of using the git command.
    substituteInPlace build.gradle \
      --replace-fail "git rev-parse --short HEAD" "cat $projectDir/libeufin-common/src/main/resources/HEAD.txt"

    # Use gradle repo to download dependencies
    substituteInPlace build.gradle \
      --replace-fail 'mavenCentral()' "gradlePluginPortal()"

    runHook postPatch
  '';

  preConfigure = ''
    cp build-system/taler-build-scripts/configure ./configure
  '';

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # this is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk17_headless}" ];
  gradleBuildTask = [
    "libeufin-bank:installShadowDist"
    "libeufin-nexus:installShadowDist"
    "libeufin-ebisync:installShadowDist"
  ];

  nativeBuildInputs = [
    customPython
    jdk17_headless
    gradle
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    make install

    for exe in libeufin-bank libeufin-nexus libeufin-ebisync ; do
      wrapProgram $out/bin/$exe \
        --set JAVA_HOME ${jdk17_headless.home} \
        --prefix PATH : $out/bin \
        --prefix PATH : ${lib.makeBinPath [ jdk17_headless ]} \

    done

    runHook postInstall
  '';

  # Tests need a database to run
  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
  ];

  env = {
    PGUSER = "nixbld";
    PGDATABASE = "libeufincheck";
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
  };

  gradleCheckTask = [
    "common:test"
    "bank:test"
    "nexus:test"
    "testbench:test"
  ];

  # TODO: tests are currently failing
  doCheck = false;

  meta = {
    homepage = "https://git.taler.net/libeufin.git/";
    description = "Integration and sandbox testing for FinTech APIs and data formats";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ atemu ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "libeufin-bank";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})
