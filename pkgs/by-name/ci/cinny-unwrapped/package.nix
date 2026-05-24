{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "cinny-unwrapped";
  # Remember to update cinny-desktop when bumping this version.
  version = "4.12.1";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s9nu6hYe0OvRcp8n2cOJnhEzIV+nyjnfwTrY477XDT8=";
  };

  npmDepsHash = "sha256-e37tSrqrEXGH2uInFAiikHNwJ13gXlG50SeYF/HO0z4=";

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
