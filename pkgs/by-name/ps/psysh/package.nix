{
  fetchFromGitHub,
  fetchurl,
  lib,
  php,
  versionCheckHook,
}:

let
  pname = "psysh";
  version = "0.12.7";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    tag = "v${version}";
    hash = "sha256-dgMUz7lB1XoJ08UvF9XMZGVXYcFK9sNnSb+pcwfeoqQ=";
  };

  composerLock = fetchurl {
    name = "composer.lock";
    url = "https://github.com/bobthecow/psysh/releases/download/v${version}/composer-v${version}.lock";
    hash = "sha256-JYJksHKyKKhU248hLPaNXFCh3X+5QiT8iNKzeGc1ZPw=";
  };
in
php.buildComposerProject2 (finalAttrs: {
  inherit
    pname
    version
    src
    ;

  composerVendor = php.mkComposerVendor {
    inherit
      src
      version
      pname
      composerLock
      ;

    preBuild = ''
      composer config platform.php 7.4
      composer require --no-cache --no-update symfony/polyfill-iconv:1.31 symfony/polyfill-mbstring:1.31
      composer require --no-cache --no-update --dev roave/security-advisories:dev-latest
      composer update --no-cache --lock --no-install
    '';

    vendorHash = "sha256-S3rekG0KPHk6cmQecmb5ETQ1V4ey5+pK+PpHNSEcXNw=";
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/bobthecow/psysh/releases/tag/v${finalAttrs.version}";
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP";
    mainProgram = "psysh";
    license = lib.licenses.mit;
    homepage = "https://psysh.org/";
  };
})
