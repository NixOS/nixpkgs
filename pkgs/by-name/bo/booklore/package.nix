{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildNpmPackage,
  gradle,
  makeWrapper,
  jre,
}:
let
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "adityachandelgit";
    repo = "BookLore";
    tag = "v${version}";
    hash = "sha256-yJSfTpNEuwgCJdYf0nbUVxGFwSz1319HVmvOdyWv4W8=";
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

      makeWrapper ${lib.getExe' jre "java"} $out/bin/booklore \
        --add-flags "-jar $out/share/booklore-api/booklore-api.jar"

      runHook postInstall
    '';

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
