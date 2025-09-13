{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnInstallHook,
  nodejs,
  makeBinaryWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cloudflare-cli";
  version = "5.0.5";

  src = fetchFromGitHub {
    owner = "danielpigott";
    repo = "cloudflare-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+QlSKXkGXc72FCQAlfZnBK5tQ1jbpICxR1Xe73RSgbk=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-pPM2lKjSS6sFj5R+eaXT2mXoCQouq4UleCN1IQilnnw=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnInstallHook
    nodejs
    makeBinaryWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/cfcli \
      --chdir $out/lib/node_modules/cloudflare-cli
  '';

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
