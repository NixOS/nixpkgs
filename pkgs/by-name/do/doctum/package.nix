{
  lib,
  fetchFromGitHub,
  php,
}:
php.buildComposerProject2 (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;
  pname = "doctum";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "code-lts";
    repo = "doctum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-faGPhR37VUtHeXWpL3jjPNsAX7WOTJ01+s1VeozYyJ0=";
  };

  composerLock = ./composer.lock;

  vendorHash = "sha256-iAD6F7MEq5+aGpJv/f1Sw2RRMsQ4d4pBflAyzfwhAnw=";

  meta = {
    description = "A PHP API documentation generator";
    homepage = "https://doctum.long-term.support";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      OulipianSummer
    ];
    platforms = php.meta.platforms;
    mainProgram = "doctum.php";
  };
})
