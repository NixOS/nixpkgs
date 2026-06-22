{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
  nix-update-script,
}:

let
  pnpm = pnpm_11;
in
buildNpmPackage (finalAttrs: {
  pname = "nezha-theme-user";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "hamster1963";
    repo = "nezha-dash-v2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X7NRpDeZqLijgbUQOEdML00TPRM2D55zlJkzWB2TKfM=";
  };

  postPatch = ''
    # We cannot directly get the git commit hash from the tarball
    substituteInPlace vite.config.ts \
      --replace-fail 'git rev-parse --short HEAD' 'echo ${finalAttrs.src.rev}'
    substituteInPlace src/components/Footer.tsx \
      --replace-fail '/commit/' '/tree/'
  '';

  nativeBuildInputs = [ pnpm ];

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-4Zfiw//9w16I2CXOEy/ocAI5frK5w4g3b8pxguGWOdA=";
  };
  npmConfigHook = pnpmConfigHook;

  dontNpmInstall = true;
  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nezha monitoring user frontend based on next.js";
    changelog = "https://github.com/hamster1963/nezha-dash-v2/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/hamster1963/nezha-dash-v2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
