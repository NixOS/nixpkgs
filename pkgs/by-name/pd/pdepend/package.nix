{ php, fetchFromGitHub, lib }:

php.buildComposerProject (finalAttrs: {
  pname = "pdepend";
  version = "2.15.1";

  src = fetchFromGitHub {
    owner = "pdepend";
    repo = "pdepend";
    rev = finalAttrs.version;
    hash = "sha256-tVWOR0rKMnQDeHk3MHhEVOjn+dSpoMx+Ln+AwFRMwYs=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-MWm8urRB9IujqrIl22x+JFFCRR+nINLQqnHUywT2pi0=";

  meta = {
    description = "An adaptation of JDepend for PHP";
    homepage = "https://github.com/pdepend/pdepend";
    license = lib.licenses.bsd3;
    longDescription = "
      PHP Depend is an adaptation of the established Java
      development tool JDepend. This tool shows you the quality
      of your design in terms of extensibility, reusability and
      maintainability.
    ";
    maintainers = lib.teams.php.members;
    platforms = lib.platforms.all;
  };
})
