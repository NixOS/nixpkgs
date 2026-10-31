{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "martian-grotesk";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "evilmartians";
    repo = "grotesk";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-uz3otulwnLKArUFLdraWXL93hpIYiJf5kgZ+7cYB2RE=";
  };
  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/opentype/ ./fonts/otf/*.otf

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Free and open-source variable sans-serif font from Evil Martians";
    homepage = "https://github.com/evilmartians/grotesk";
    changelog = "https://github.com/evilmartians/grotesk/raw/v${finalAttrs.version}/Changelog.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
