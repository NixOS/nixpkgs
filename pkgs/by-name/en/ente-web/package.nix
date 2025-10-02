{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarnConfigHook,
  yarnBuildHook,
  nix-update-script,
  extraBuildEnv ? { },
  # This package contains serveral sub-applications. This specifies which of them you want to build.
  enteApp ? "photos",
  # Accessing some apps (such as account) directly will result in a hardcoded redirect to ente.io.
  # To prevent users from accidentally logging in to ente.io instead of the selfhosted instance, you
  # can set this parameter to override these occurrences with your own url. Must include the schema.
  # Example: https://my-ente.example.com
  enteMainUrl ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ente-web-${enteApp}";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [ "web" ];
    tag = "photos-v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-KCRwQmYmf2DXe3WQS8Rc8h397F0xEth4x36Yz4Ke4Y0=";
  };
  sourceRoot = "${finalAttrs.src.name}/web";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/web/yarn.lock";
    hash = "sha256-vm1pQrS4yWvSeTo++964kM+OK0JED8et/dHqLG6lJH0=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  # See: https://github.com/ente-io/ente/blob/main/web/apps/photos/.env
  env = extraBuildEnv;

  # Replace hardcoded ente.io urls if desired
  postPatch = lib.optionalString (enteMainUrl != null) ''
    substituteInPlace \
      apps/payments/src/services/billing.ts \
      apps/photos/src/pages/shared-albums.tsx \
      --replace-fail "https://ente.io" ${lib.escapeShellArg enteMainUrl}

    substituteInPlace \
      apps/accounts/src/pages/index.tsx \
      --replace-fail "https://web.ente.io" ${lib.escapeShellArg enteMainUrl}
  '';

  yarnBuildScript = "build:${enteApp}";
  installPhase =
    let
      distName = if enteApp == "payments" then "dist" else "out";
    in
    ''
      runHook preInstall

      cp -r apps/${enteApp}/${distName} $out

      runHook postInstall
    '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "photos-v(.*)"
    ];
  };

  meta = {
    description = "Ente application web frontends";
    homepage = "https://ente.io/";
    changelog = "https://github.com/ente-io/ente/releases";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      pinpox
      oddlama
    ];
    platforms = lib.platforms.all;
  };
})
