{
  callPackage,
  fetchFromGitHub,
  lib,
  pkgs,
  php ? pkgs.php85,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "strichliste-backend";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "strichliste";
    repo = "strichliste-backend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yI20cUp19ehtOnWdu+MItwgOlNDnt1VK3giInaTQQ4Y=";
  };

  vendorHash = "sha256-vYPjUaNIf62GoKXopC4nGqIa+Z3C8Q5dnX9FPvM1Ers=";
  composerNoDev = true;
  composerStrictValidation = false;

  postPatch = ''
    substituteInPlace config/services.yaml \
      --replace-fail "strichliste.yaml" "/etc/strichliste.yaml"
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
  };

  meta = {
    description = "strichliste is a tool to replace a tally sheet.";
    homepage = "https://www.strichliste.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "strichliste-console";
    platforms = lib.platforms.all;
  };
})
