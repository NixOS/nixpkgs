{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cloudflare-cli";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "danielpigott";
    repo = "cloudflare-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cT+cMekXhHKfFi+dH1dCA/YNBSyYePJIZBSkDMPZZ14=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-0SFXgaLQE/MkqC9id7DAiP422tEyTt2gpgpIdXViFBI=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnInstallHook
    nodejs
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/cfcli --help >/dev/null

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for interacting with Cloudflare";
    homepage = "https://github.com/danielpigott/cloudflare-cli";
    changelog = "https://github.com/danielpigott/cloudflare-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "cfcli";
  };
})
