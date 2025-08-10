{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "qwen-code";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "QwenLM";
    repo = "qwen-code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/PuykGiXpjk2Fp1Sif59hvOIepZ7KcJRvL/9RMatQJA=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-HzrN549MfI+TN7BKssisIsga7udGKvextruzuoLq8M4=";
  };

  buildPhase = ''
    runHook preBuild

    npm run generate
    npm run bundle

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r bundle/* $out/
    patchShebangs $out
    ln -s $out/gemini.js $out/bin/qwen

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Coding agent that lives in digital world";
    homepage = "https://github.com/QwenLM/qwen-code";
    mainProgram = "qwen";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lonerOrz ];
  };
})
