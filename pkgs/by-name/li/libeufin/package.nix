{
  lib,
  stdenv,
  fetchgit,
  python3,
  jdk17_headless,
  gradle,
  makeWrapper,
  postgresql,
  postgresqlTestHook,
}:
let
  customPython = python3.withPackages (p: [ p.setuptools ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libeufin";
  version = "0.11.3";

  src = fetchgit {
    url = "https://git.taler.net/libeufin.git/";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6bMYcpxwL1UJXt0AX6R97C0Orwqb7E+TZO2Sz1qode8=";
    fetchSubmodules = true;
    leaveDotGit = true; # required for correct submodule fetching
    # Delete .git folder for reproducibility (otherwise, the hash changes unexpectedly after fetching submodules)
    # Save the HEAD short commit hash in a file so it can be retrieved later for versioning.
    postFetch = ''
      pushd $out
      git rev-parse --short HEAD > ./common/src/main/resources/HEAD.txt
      rm -rf .git
      popd
    '';
  };

  patchPhase = ''
    runHook prePatch

    # The .git folder had to be deleted. Read hash from file instead of using the git command.
    substituteInPlace build.gradle \
      --replace-fail "commandLine 'git', 'rev-parse', '--short', 'HEAD'" 'commandLine "cat", "$projectDir/common/src/main/resources/HEAD.txt"'

    # Gradle projects provide a .module metadata file as artifact. This artifact is used by gradle
    # to download dependencies to the cache when needed, but do not provide the jar for the
    # offline installation for our build phase. Since we make an offline Maven repo, we have to
    # substitute the gradle deps for their maven counterpart to retrieve the .jar artifacts.
    for dir in common bank nexus testbench; do
      substituteInPlace $dir/build.gradle \
        --replace-fail ':$ktor_version' '-jvm:$ktor_version' \
        --replace-fail ':$clikt_version' '-jvm:$clikt_version'
    done

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
    "bank:installShadowDist"
    "nexus:installShadowDist"
  ];

  nativeBuildInputs = [
    customPython
    jdk17_headless
    gradle
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    make install-nobuild

    for exe in libeufin-nexus libeufin-bank ; do
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
    mainProgram = "libeufin-bank";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})
