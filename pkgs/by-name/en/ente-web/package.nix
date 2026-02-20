{
  lib,
  stdenv,
  binaryen,
  cargo,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  rustPlatform,
  rustc,
  wasm-bindgen-cli_0_2_106,
  wasm-pack,
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
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [
      "rust"
      "web"
    ];
    tag = "photos-v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Bfu4O+kBtXxxVyx2iC/577TPD049ifjg1ItmKN4bx4U=";
  };
  sourceRoot = "${finalAttrs.src.name}/web";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      cargoRoot
      ;
    hash = "sha256-dedLmQP15V+gAtycXx1fpWfjXWsTPLXPPcCIAcr/ME0=";
  };
  cargoRoot = "packages/wasm";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/web/yarn.lock";
    hash = "sha256-OPmO+4VlM4Fy9vjgb2ZxDP6Ber9A+ANwix1dZSuEgUE=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    binaryen
    cargo
    rustPlatform.cargoSetupHook
    rustc
    rustc.llvmPackages.lld
    nodejs
    wasm-bindgen-cli_0_2_106
    wasm-pack
  ];

  # See: https://github.com/ente-io/ente/blob/main/web/apps/photos/.env
  env = extraBuildEnv;

  postPatch =
    # Use our `wasm-pack` binary, rather than the Node version, which is
    # just a wrapper that tries to download the actual binary
    ''
      substituteInPlace \
        packages/wasm/package.json \
        --replace-fail "wasm-pack " ${lib.escapeShellArg "${wasm-pack}/bin/wasm-pack "}
    ''
    # Replace hardcoded ente.io urls if desired
    + lib.optionalString (enteMainUrl != null) ''
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
      nicegamer7
    ];
    platforms = lib.platforms.all;
  };
})
