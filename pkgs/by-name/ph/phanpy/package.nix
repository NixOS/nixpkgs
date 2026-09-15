{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  config,
  writeText,
  conf ? config.phanpy.conf or null,
}:

buildNpmPackage (finalAttrs: {
  pname = "phanpy";
  version = "2025.07.18.3f4b1a6";

  src = fetchFromGitHub {
    owner = "cheeaun";
    repo = "phanpy";
    tag = "${finalAttrs.version}";
    hash = "sha256-0OkH/XojM0W2oun797sNJqFrxNqFau1P+NECxCrib20=";
  };

  npmDepsHash = "sha256-2a+5G0ENpjOvw+TuxEJrkabAB3uoQnaBQc7Nek7a/dw=";

  preBuild = lib.optionalString (conf != null) ''
    ${writeText ".env" conf}
  '';

  installPhase = ''
    cp -ar dist $out
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimalistic opinionated Mastodon web client";
    homepage = "https://phanpy.social/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dvn0
    ];
    mainProgram = "phanpy";
  };
})
