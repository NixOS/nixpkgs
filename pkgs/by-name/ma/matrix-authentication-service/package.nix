{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm,
  pnpmConfigHook,
  nodejs,
  python3,
  pkg-config,
  sqlite,
  zstd,
  stdenv,
  open-policy-agent,
  cctools,
  nix-update-script,
  versionCheckHook,
  buildPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matrix-authentication-service";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "matrix-authentication-service";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0fvGhBxwXhSzWvNhflreEFoCBycM10vMkMf4sj95vfY=";
  };

  cargoHash = "sha256-3V50qNvg24WZvQ9z7IZJAnPXHTibZ6o3EzUoinLU6Gw=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 4;
    hash = "sha256-j2A2VCKQPfoyrNDtazu8hzUHpS130Ju/Cy3yfu9tC5I=";
  };

  pnpmRoot = "frontend";

  nativeBuildInputs = [
    pkg-config
    open-policy-agent
    pnpmConfigHook
    pnpm
    nodejs
    (python3.withPackages (ps: [ ps.setuptools ])) # Used by gyp
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin cctools; # libtool used by gyp;

  buildInputs = [
    sqlite
    zstd
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    VERGEN_GIT_DESCRIBE = finalAttrs.version;
  };

  buildNoDefaultFeatures = true;

  buildFeatures = [ "dist" ];

  postPatch = ''
    substituteInPlace crates/config/src/sections/http.rs \
      --replace-fail ./share/assets/    "$out/share/$pname/assets/"
    substituteInPlace crates/config/src/sections/templates.rs \
      --replace-fail ./share/templates/    "$out/share/$pname/templates/" \
      --replace-fail ./share/translations/    "$out/share/$pname/translations/" \
      --replace-fail ./share/manifest.json "$out/share/$pname/assets/manifest.json"
    substituteInPlace crates/config/src/sections/policy.rs \
      --replace-fail ./share/policy.wasm "$out/share/$pname/policy.wasm"
  '';

  preBuild =
    let
      buildTarget = stdenv.buildPlatform.rust.rustcTarget;
      buildTargetUnderscore = lib.replaceString "-" "_" buildTarget;
    in
    ''
      make -C policies
      (cd "$pnpmRoot" && npm run build)

      # Fix aws-lc-sys cross-compilation
      export CC_${buildTargetUnderscore}=$CC_FOR_BUILD
      export CXX_${buildTargetUnderscore}=$CXX_FOR_BUILD
    '';

  # Adapted from https://github.com/element-hq/matrix-authentication-service/blob/v0.20.0/.github/workflows/build.yaml#L75-L84
  postInstall = ''
    install -Dm444 -t "$out/share/$pname"        "policies/policy.wasm"
    install -Dm444 -t "$out/share/$pname"        "$pnpmRoot/dist/manifest.json"
    install -Dm444 -t "$out/share/$pname/assets" "$pnpmRoot/dist/"*
    cp -r templates   "$out/share/$pname/templates"
    cp -r translations   "$out/share/$pname/translations"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  passthru.updateScript = nix-update-script {
    extraArgs = [
      # avoid unstable pre‐releases
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "OAuth2.0 + OpenID Provider for Matrix Homeservers";
    homepage = "https://github.com/element-hq/matrix-authentication-service";
    changelog = "https://github.com/element-hq/matrix-authentication-service/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.matrix ];
    mainProgram = "mas-cli";
  };
})
