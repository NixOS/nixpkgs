{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lain-grub-theme";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "uiriansan";
    repo = "LainGrubTheme";
    tag = "${finalAttrs.version}";
    hash = "sha256-qk0uadFVTQeproT8ZODTYTDg7BBd5Ae4XQekWEWyBHQ=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -r lain $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Serial Experiments Lain theme for GRUB";
    homepage = "https://github.com/uiriansan/LainGrubTheme";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Levizor ];
    platforms = lib.platforms.linux;
  };
})
