{
  lib,
  buildNpmPackage,
  fetchFromGitea,
  nix-update-script,
  npmBuildScript ? "build",
}:
buildNpmPackage (finalAttrs: {
  pname = "garage-webadmin";
  version = "0.2.3";

  src = fetchFromGitea {
    domain = "git.deuxfleurs.fr";
    owner = "Deuxfleurs";
    repo = "garage-webadmin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hTqlI70P/zAvhbfPYvQYNzXXGrSiRKcIqJlV4WrFI5g=";
  };

  npmDepsHash = "sha256-0Prl8WwuP6sntxc2luN96Bpfmgk9RYodNMcpCtzCqr0=";

  npmBuildScript = npmBuildScript;

  # https://github.com/cyyynthia/vite-plugin-magical-svg/pull/35
  preBuild = ''
    substituteInPlace node_modules/vite-plugin-magical-svg/dist/index.js \
      --replace-fail \
        'await transformRefs(asset.xml.svg, async (ref, isFile) => {' \
        'if (asset.xml.svg["#sprite"]) asset.xml.svg.$$.sort((a, b) => a.$.id.localeCompare(b.$.id)); await transformRefs(asset.xml.svg, async (ref, isFile) => {'
  '';

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Web admin UI for Garage";
    changelog = "https://git.deuxfleurs.fr/Deuxfleurs/garage-webadmin/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://git.deuxfleurs.fr/Deuxfleurs/garage-webadmin";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      herbetom
      anish
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
