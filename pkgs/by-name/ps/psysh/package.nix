{
  fetchFromGitHub,
  fetchurl,
  lib,
  php,
  versionCheckHook,
}:

let
  pname = "psysh";
  version = "0.12.14";

  src = fetchFromGitHub {
    owner = "bobthecow";
    repo = "psysh";
    tag = "v${version}";
    hash = "sha256-llQdcL950wQRdRGYh2WVUyhn2ODRubYN30ZIQxmlifk=";
  };

  composerLock = fetchurl {
    name = "composer.lock";
    url = "https://github.com/bobthecow/psysh/releases/download/v${version}/composer-v${version}.lock";
    hash = "sha256-RNoR/bNj9688D8tRNA4yPi/RRSYoGrDoWY84yU8bbto=";
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
      composer require --no-update symfony/polyfill-iconv:1.33 symfony/polyfill-mbstring:1.33
      composer require --no-update --dev roave/security-advisories:dev-latest
      composer update --lock --no-install
    '';

    vendorHash = "sha256-fHI6o/kAKIkaX7O482eyKB13EfvHr1gwTPvT1XgFs1w=";
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
