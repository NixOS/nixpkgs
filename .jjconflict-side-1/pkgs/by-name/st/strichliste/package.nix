{
  callPackage,
  fetchFromGitHub,
  lib,
  pkgs,
  php ? pkgs.php85,
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "strichliste-backend";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "strichliste";
    repo = "strichliste-backend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ps0IJBXVchPaW2Tx4rfD02EFYiv3oTyaNB6/V7txeM0=";
  };

  vendorHash = "sha256-PLq+XiZIJyyzVq+87timGO/jbPB4ZYQqSZilZMIE4Cw=";
  composerNoDev = true;
  composerNoPlugins = false;
  composerStrictValidation = true;

  postPatch = ''
    substituteInPlace config/services.yaml \
      --replace-fail "strichliste.yaml" "/etc/strichliste.yaml"
  '';

  postBuild = ''
    composer dump-autoload --optimize --no-dev --no-scripts --no-interaction --no-cache
  '';

  postInstall = ''
    mkdir $out/bin
    ln -s $out/share/php/strichliste-backend/bin/console $out/bin/strichliste-console
  '';

  __structuredAttrs = true;

  passthru = {
    frontend = callPackage ./frontend.nix {
      inherit (finalAttrs) meta;
    };
    phpPackage = php;
    tests = {
      inherit (nixosTests) strichliste;
    };
  };

  meta = {
    changelog = "https://github.com/strichliste/strichliste/releases/tag/${finalAttrs.src.tag}";
    description = "strichliste is a tool to replace a tally sheet.";
    homepage = "https://www.strichliste.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "strichliste-console";
    platforms = lib.platforms.all;
  };
})
