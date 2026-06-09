{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "cinny-unwrapped";
  # Remember to update cinny-desktop when bumping this version.
  version = "4.12.2";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UF5MwV02G0oYIXtvyzHn+DifYM8PFlyb9DZ4w1fuyDE=";
  };

  npmDepsHash = "sha256-8SyUFv1wgnqfSyBlykmeGI8RAmFt5Q5uS6OFLi+qPPY=";

  # Skip rebuilding native modules since they're not needed for the web app
  npmRebuildFlags = [
    "--ignore-scripts"
  ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  meta = {
    description = "Yet another Matrix client for the web";
    homepage = "https://cinny.in/";
    maintainers = with lib.maintainers; [
      abbe
      rebmit
      ryand56
    ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
  };
})
