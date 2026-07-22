{
  lib,
  rustPlatform,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs,
  nix-update-script,
  nasm,
}:
let
  pname = "scryer";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "scryer-media";
    repo = "scryer";
    tag = "scryer-v${version}";
    hash = "sha256-zIz9qsH+nTgfrpE6Aikd/fVp0wfTSzKQdE6clpVejy8=";
  };

  webui = buildNpmPackage {
    pname = "scryer-webui";
    inherit version src nodejs;

    sourceRoot = "${src.name}/apps/scryer-web";

    npmDepsHash = "sha256-5vKgjayikva5RxF7C8vI+iwRHs1fXV2QG55rpL51KaA=";

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
  __structuredAttrs = true;

  cargoHash = "sha256-82AQ90QHNpTExip9y/Lp7I1UNIYNdrnmLHTYNtObTYM=";

  nativeBuildInputs = [ nasm ];

  preConfigure = ''
    export SCRYER_EMBED_UI_DIR=${webui}
  '';

  passthru = {
    inherit webui;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Self-hosted media management application for movies, TV series, and anime";
    homepage = "https://www.scryer.media";
    changelog = "https://github.com/scryer-media/scryer/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jagu-sayan ];
    mainProgram = "scryer";
  };
}
