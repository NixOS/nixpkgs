{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  nodejs_22,
}:

buildNpmPackage (finalAttrs: {
  pname = "paseo-hub";
  version = "0.10.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "getpaseo";
    repo = "hub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3OToY+Ncm2mS54BN2ZMKz/gLnBgENIG6ig2SSB8a+rE=";
  };

  # upstream has an invalid dep https://github.com/getpaseo/hub/pull/149
  postPatch = ''
    substituteInPlace package-lock.json --replace-fail hubflare cloudflare
  '';

  nodejs = nodejs_22;
  npmDepsHash = "sha256-lBePEjJFJ2we9Yx8/KK3lYw6G1S46mIFrBZRAbvWw+c=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Self-hosted automation for Paseo daemons";
    homepage = "https://github.com/getpaseo/hub";
    changelog = "https://github.com/getpaseo/hub/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "paseo-hub";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
