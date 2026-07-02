{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  nix-update-script,
  writers,
  baseUrl ? null,
}:

assert lib.asserts.assertMsg (
  baseUrl == null
) "The baseUrl parameter is deprecated, please use .withConfig instead";

stdenv.mkDerivation (finalAttrs: {
  pname = "ketesa";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "etkecc";
    repo = "ketesa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yg5M3D4etEVwLXT5+QSLqebJwBIpRKV43nYycKSi/tw=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-mLFCVt2LsF4/evlVyTXEdSSk4aDU2tF2m3v8j8eX8ng=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
  ];

  env = {
    NODE_ENV = "production";
    KETESA_VERSION = finalAttrs.version;
  };

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  __darwinAllowLocalNetworking = true;

  passthru = {
    # https://github.com/etkecc/ketesa/blob/main/docs/config.md
    withConfig =
      config:
      stdenv.mkDerivation {
        inherit (finalAttrs) version meta;
        pname = "ketesa-with-config";
        dontUnpack = true;
        configFile = writers.writeJSON "ketesa-config" config;
        installPhase = ''
          runHook preInstall
          cp -r ${finalAttrs.finalPackage} $out
          chmod -R +w $out
          cp $configFile $out/config.json
          runHook postInstall
        '';
      };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Admin UI for Matrix servers, formerly Synapse Admin. Drop-in replacement with extended features, multi-backend support, and visual customization";
    homepage = "https://github.com/etkecc/ketesa";
    changelog = "https://github.com/etkecc/ketesa/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ defelo ];
  };
})
