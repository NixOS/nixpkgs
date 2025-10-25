{
  lib,
  stdenvNoCC,
  nixosTests,
  fetchFromGitHub,
  buildNpmPackage,
  gradle_9,
  makeWrapper,
  openjdk25,
}:
let
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "adityachandelgit";
    repo = "BookLore";
    tag = "v${version}";
    hash = "sha256-FxvVqaicqOq3h3Oy+tGKc0AnBBabpIRGZ0diniBQrEQ=";
  };

  webui = buildNpmPackage {
    pname = "booklore-ui";
    inherit version;

    src = src + "/booklore-ui";

    npmFlags = [ "--legacy-peer-deps" ];
    npmDepsHash = "sha256-ETzFwSNF+qLuiKdnkwsd9LUqEtNf5fJpgmO4+rfnWr8=";

    installPhase = ''
      runHook preInstall

      cp -r dist/booklore/browser $out

      runHook postInstall
    '';
  };

  gradle = gradle_9.override { java = openjdk25; };

  booklore = stdenvNoCC.mkDerivation (final: {
    pname = "booklore";
    inherit version;

    src = src + "/booklore-api";

    postPatch = ''
      sed -i "s/version: 'v.*'/version: 'v${version}'/" src/main/resources/application.yaml

      substituteInPlace src/main/resources/application.yaml \
        --replace-fail "'/app/data'" "\''${BOOKLORE_DATA_DIR:/var/lib/booklore/data}" \
        --replace-fail "'/bookdrop'" "\''${BOOKLORE_BOOKDROP_DIR:/var/lib/booklore/bookdrop}"
    '';

    nativeBuildInputs = [
      gradle
      makeWrapper
    ];

    mitmCache = gradle.fetchDeps {
      inherit (final) pname;
      pkg = booklore;
      data = ./deps.json;
    };

    gradleBuildTask = "build";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/booklore-api
      cp build/libs/booklore-api-*-SNAPSHOT.jar $out/share/booklore-api/booklore-api.jar
      ln -s ${webui} $out/share/booklore-ui

      makeWrapper ${lib.getExe' openjdk25 "java"} $out/bin/booklore \
        --add-flags "-jar $out/share/booklore-api/booklore-api.jar"

      runHook postInstall
    '';

    passthru.tests = nixosTests.booklore;

    meta = {
      description = "Web app for hosting, managing, and exploring books, with support for PDFs, eBooks, reading progress, metadata, and stats";
      mainProgram = "booklore";
      homepage = "https://github.com/adityachandelgit/BookLore";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ jvanbruegge ];
      platforms = [ "x86_64-linux" ];
    };
  });
in
booklore
