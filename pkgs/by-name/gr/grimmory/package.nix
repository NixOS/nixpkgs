{
  fetchFromGitHub,
  fetchPnpmDeps,
  gradle_9,
  jdk25,
  lib,
  makeWrapper,
  nixosTests,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
  stdenvNoCC,
  writeText,
}:
let
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "grimmory-tools";
    repo = "grimmory";
    rev = "v${version}";
    hash = "sha256-PO+JVYQPKtoY4oxkd/TGrT0L2/Mm1rI65fj5Zg3iCbw=";
  };

  frontend = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "grimmory-frontend";
    inherit version src;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_11
    ];

    pnpmWorkspaces = [ "grimmory" ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        pnpmWorkspaces
        ;
      pnpm = pnpm_11;
      fetcherVersion = 4;
      hash = "sha256-pVPxfIUD2euFh7myOx2lwleWdM15myfBfiCbYNfYACY=";
    };

    env = {
      CI = "1";
      NG_CLI_ANALYTICS = "false";
    };

    buildPhase = ''
      runHook preBuild
      pnpm --filter=grimmory run build:prod
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r frontend/dist/grimmory/browser $out
      runHook postInstall
    '';
  });
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "grimmory";
  inherit version src;

  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/backend";

  nativeBuildInputs = [
    gradle_9
    jdk25
    makeWrapper
  ];

  gradleInitScript = writeText "grimmory-empty-init-script.gradle" "";

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk25}"
    "-Dorg.gradle.java.installations.auto-download=false"
  ];

  gradleBuildTask = "bootJar";

  doCheck = false;

  mitmCache = gradle_9.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  preConfigure = ''
    cp -r ${frontend} frontend-dist
    chmod -R u+w frontend-dist
    gradleFlagsArray+=("-PfrontendDistDir=$PWD/frontend-dist")
  '';

  installPhase = ''
    runHook preInstall

    mapfile -t jar_paths < <(find build/libs -maxdepth 1 -name '*.jar' ! -name '*plain.jar')
    if [ "''${#jar_paths[@]}" -ne 1 ]; then
      printf 'Expected exactly one executable jar, found %s:\n' "''${#jar_paths[@]}" >&2
      printf '  %s\n' "''${jar_paths[@]}" >&2
      exit 1
    fi
    install -Dm444 "''${jar_paths[0]}" $out/share/grimmory/grimmory.jar

    makeWrapper ${lib.getExe' jdk25 "java"} $out/bin/grimmory \
      --add-flags "--enable-native-access=ALL-UNNAMED --enable-preview -jar $out/share/grimmory/grimmory.jar"

    runHook postInstall
  '';

  passthru = {
    inherit frontend;
    tests = nixosTests.grimmory;
  };

  meta = {
    description = "Self-hosted digital library for EPUB, PDF and comics (community fork of Booklore)";
    homepage = "https://github.com/grimmory-tools/grimmory";
    license = lib.licenses.agpl3Only;
    mainProgram = "grimmory";
    maintainers = with lib.maintainers; [ alvr ];
    platforms = lib.platforms.linux;
  };
})
