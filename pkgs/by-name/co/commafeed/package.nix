{
  lib,
  biome,
  buildNpmPackage,
  fetchFromGitHub,
  jdk25,
  maven,
  makeWrapper,
  unzip,
  nixosTests,
  writeText,
  stdenv,
  nix-update-script,
}:
let
  version = "7.4.1";

  src = fetchFromGitHub {
    owner = "Athou";
    repo = "commafeed";
    tag = version;
    hash = "sha256-r0JQ07Aa8TPclBEOznCEuH6QvvVbgdIO5GWIwPFv0Hs=";
  };

  frontend = buildNpmPackage {
    inherit version src;

    pname = "commafeed-frontend";

    sourceRoot = "${src.name}/commafeed-client";

    npmDepsHash = "sha256-CHb84GlbbUq7hH8SbfC4eN2a90Xuc1RUsVSf4lMVSss=";

    nativeBuildInputs = [ biome ];

    installPhase = ''
      runHook preInstall

      cp -r dist/ $out

      runHook postInstall
    '';
  };

  gitProperties = writeText "git.properties" ''
    git.branch = none
    git.build.time = 1970-01-01T00:00:00+0000
    git.build.version = ${version}
    git.commit.id = none
    git.commit.id.abbrev = none
  '';
in
maven.buildMavenPackage {
  inherit version src;

  pname = "commafeed";

  mvnHash = "sha256-ikhd6X6MuglWPMFNW+Z5aulBqjZMzjEFfy9o6iw2TiA=";
  mvnJdk = jdk25;

  mvnParameters = lib.escapeShellArgs [
    "-Dskip.installnodenpm"
    "-Dskip.npm"
    "-Dspotless.check.skip"
    "-Dmaven.gitcommitid.skip"
  ];

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  configurePhase = ''
    runHook preConfigure

    ln -sf "${frontend}" commafeed-client/dist

    cp ${gitProperties} commafeed-server/src/main/resources/git.properties

    runHook postConfigure
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    unzip -d $out/share/ commafeed-server/target/commafeed-$version-h2-jvm.zip

    makeWrapper ${jdk25}/bin/java $out/bin/commafeed \
      --add-flags "-jar $out/share/commafeed-$version-h2/quarkus-run.jar"

    runHook postInstall
  '';

  passthru = {
    inherit frontend;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
    tests = nixosTests.commafeed;
  };

  meta = {
    description = "Google Reader inspired self-hosted RSS reader";
    homepage = "https://github.com/Athou/commafeed";
    license = lib.licenses.asl20;
    mainProgram = "commafeed";
    maintainers = with lib.maintainers; [ svrana ];
    broken = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isAarch64;
  };
}
