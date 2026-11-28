{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "rclone-web";
  version = "1.1.13";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rclone";
    repo = "rclone-web";
    tag = finalAttrs.version;
    hash = "sha256-DB/haO7y3k/BdIT2JDO5KtK6utYLGgPiosDaWCGhw/4=";
  };

  npmDepsHash = "sha256-eorRQSgnCuKD/WBbvlgX9gFEdlh9/ieUyOaF1WH2qhc=";

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web interface for rclone";
    homepage = "https://github.com/rclone/rclone-web";
    changelog = "https://github.com/rclone/rclone-web/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ znaniye ];
    platforms = lib.platforms.all;
  };
})
