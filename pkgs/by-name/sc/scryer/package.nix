{
  lib,
  rustPlatform,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs,
  nix-update-script,
  nasm,
}: let
  pname = "scryer";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "scryer-media";
    repo = pname;
    rev = "${pname}-v${version}";
    hash = "sha256-Muu4vl2mM7QWWUBgLp6OHrFnJ8xFUWs/8wkQt4AfVRs=";
  };

  scryer-webui = buildNpmPackage {
    pname = "${pname}-webui";
    inherit version src nodejs;

    sourceRoot = "${src.name}/apps/scryer-web";

    npmDepsHash = "sha256-ZFAVVZNJIz/VvRrr1ml9prTvmp7PzitBbB9q2bNe7yI=";

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r dist/* $out/

      runHook postInstall
    '';
  };
in
  rustPlatform.buildRustPackage {
    inherit pname version src;

    cargoHash = "sha256-7pnBg8B3dteWgF9PTaqovzpPeoY6+G48sqj2mHBUv54=";

    nativeBuildInputs = [nasm];

    preConfigure = ''
      export SCRYER_EMBED_UI_DIR=${scryer-webui}
    '';

    passthru = {
      webui = scryer-webui;
      updateScript = nix-update-script {};
    };

    meta = {
      description = "Self-hosted media management application for movies, TV series, and anime";
      homepage = "https://www.scryer.media";
      changelog = "https://github.com/scryer-media/scryer/releases/tag/${pname}-v${version}";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [jagu];
      mainProgram = pname;
    };
  }
