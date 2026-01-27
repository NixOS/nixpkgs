{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  php,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hotcrp";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "kohler";
    repo = "hotcrp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qRLC6VJhEjcmHRFViefniE+wUvWbdhV9pP1FQvdjPvU=";
  };

  installPhase = ''
    runHook preInstall
    cp -R . $out
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Conference review software";
    homepage = "https://read.seas.harvard.edu/~kohler/hotcrp/";
    downloadPage = "https://github.com/kohler/hotcrp";
    changelog = "https://github.com/kohler/hotcrp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.free; # MIT-like custom license
    platforms = php.meta.platforms;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
})
