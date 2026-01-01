{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nuclei-templates";
<<<<<<< HEAD
  version = "10.3.6";
=======
  version = "10.3.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "nuclei-templates";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lDGRpdtqG7O8gzYb0enwPNrXVeWRaNWT67gdgU4hOpg=";
=======
    hash = "sha256-8zb+s5XLa5t0DklswqKiFoAvcXyNxS7QgSjTySWJBGA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nuclei-templates
    cp -R cloud code dast dns file headless helpers http javascript network profiles ssl \
      $out/share/nuclei-templates/

    runHook postInstall
  '';

  meta = {
    description = "Templates for the nuclei engine to find security vulnerabilities";
    homepage = "https://github.com/projectdiscovery/nuclei-templates";
    changelog = "https://github.com/projectdiscovery/nuclei-templates/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.all;
  };
}
