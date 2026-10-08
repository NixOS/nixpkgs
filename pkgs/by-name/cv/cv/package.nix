{
  lib,
  php,
  fetchFromGitHub,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "cv";
  version = "0.3.72";
  __structuredAttrs = true;
  strictDeps = true;
  dontUnpack = false;

  src = fetchFromGitHub {
    owner = "civicrm";
    repo = "cv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-haK/DYas0KJjOEyqFcGqGbf2dAikbR7XFdI15fHcZcg=";
  };

  vendorHash = "sha256-gL0mleLCSDvR93oQW+O//j/ANs7oYYKfKgGOGQkCFJI=";

  installPhase = ''
    runHook preInstall
    cp -ra $src $out
    runHook postInstall
  '';
  meta = {
    homepage = "https://civicrm.org/";
    changelog = "https://github.com/civicrm/cv/releases/tag/v${finalAttrs.version}";
    description = "CiviCRM CLI Utility";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.sorooris ];
  };
})
