{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  clojure,
  installShellFiles,
  jdk21_headless,
  makeBinaryWrapper,
  sphinx,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pgloader";
  # pgloader has no v4 release yet
  version = "4.0.0-unstable-2026-07-24";

  src = fetchFromGitHub {
    owner = "dimitri";
    repo = "pgloader";
    rev = "ea152ef47711af0cc821067b95065e9f2e76c45b";
    hash = "sha256-TpQ9Y9rM1qQnQx54uKjyu1/FjyDO3PsZQzeLt657MrQ=";
  };

  mvnDeps = stdenvNoCC.mkDerivation {
    name = "pgloader-${finalAttrs.version}-maven-deps";
    inherit (finalAttrs) src;

    nativeBuildInputs = [
      clojure
      jdk21_headless
    ];

    buildPhase = ''
      runHook preBuild

      export HOME="$(mktemp -d)"
      mkdir -p "$out"

      cd clojure

      clojure -Sdeps "{:mvn/local-repo \"$out\"}" -P
      clojure -Sdeps "{:mvn/local-repo \"$out\"}" -P -T:build

      runHook postBuild
    '';

    # make the output reproducible:
    # delete all ephemeral files with lastModified timestamps
    installPhase = ''
      runHook preInstall

      find "$out" -type f \( \
        -name \*.lastUpdated \
        -o -name resolver-status.properties \
        -o -name _remote.repositories \) \
        -delete

      runHook postInstall
    '';

    dontFixup = true;

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-pL+U/SCNRq0+48ec99I8j8qN8vXIJ3OMa6ue9cHZrsQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    clojure
    installShellFiles
    jdk21_headless
    makeBinaryWrapper
    sphinx
  ];

  env.PGLOADER_VERSION = finalAttrs.version;

  buildPhase = ''
    runHook preBuild

    export HOME="$TMPDIR"

    mvnRepo="$PWD/mvn-repo"
    cp -r ${finalAttrs.mvnDeps} "$mvnRepo"
    chmod -R u+w "$mvnRepo"

    substituteInPlace clojure/deps.edn \
      --replace-fail '{:paths' "{:mvn/local-repo \"$mvnRepo\" :paths"

    pushd clojure
    clojure -Sdeps "{:mvn/local-repo \"$mvnRepo\"}" -T:build uber
    popd

    # build man pages
    sphinx-build -b man docs man

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 "clojure/target/pgloader-v4-${finalAttrs.version}.jar" \
      "$out/share/pgloader/pgloader.jar"

    makeWrapper ${lib.getExe' jdk21_headless "java"} "$out/bin/pgloader" \
      --add-flags "-jar $out/share/pgloader/pgloader.jar"

    installManPage man/*.1

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    export HOME="$TMPDIR"
    # Assert that the binary works / does not crash
    "$out/bin/pgloader" --version

    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://pgloader.io/";
    description = "Loads data into PostgreSQL and allows you to implement Continuous Migration from your current database to PostgreSQL";
    mainProgram = "pgloader";
    maintainers = with lib.maintainers; [ mguentner ];
    license = lib.licenses.postgresql;
    platforms = lib.platforms.unix;
  };
})
