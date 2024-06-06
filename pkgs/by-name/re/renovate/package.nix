{ fetchFromGitHub,
  nodejs_20,
  pnpm_9,
  stdenvNoCC,
  lib,
}:

let
  nodejs = nodejs_20;
  pnpm = pnpm_9;
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "renovate";
  version = "37.393.0";

  src = fetchFromGitHub {
    owner = "renovatebot";
    repo = "renovate";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-YgxcGNMgmwrausdR7kvG1NiyQPn0FcCq/isf9qUDCFY=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  # renovate pins their pnpm version, this bypasses the check
  COREPACK_ENABLE_STRICT = "0";

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    pnpm deploy --offline --filter renovate --ignore-script --prod --force $out

    runHook postInstall
  '';

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Zbe561q6xDKDIN+E/2eyQMz2GtpPvJEv2pAauMa+8pE=";
  };
})
