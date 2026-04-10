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
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "danielpigott";
    repo = "cloudflare-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KDL9UGsBVH+BxeMwpcwqH0P0Y8QbFMSqNT5FrTZxDog=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-30zvP1sYENfTh8o/RiSrYPZR3to3GF2m036q/+mrcSU=";
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
