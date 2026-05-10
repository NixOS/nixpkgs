{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matrix-authentication-service";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "matrix-authentication-service";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pyL2QhvycaGBYgelsHK5Ces195Z1aY2XZyecsPXO/X4=";
  };

  cargoHash = "sha256-gvG6+strULIewJgFdGg3fJ2mjUVjgi9/Q7pDredYuiU=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    src = "${finalAttrs.src}/${finalAttrs.npmRoot}";
    hash = "sha256-FevzqirT/GyT8urQ79AtJi+q1zcwn73AyiJTf/B9cG0=";
  };

  npmRoot = "frontend";
  npmFlags = [ "--legacy-peer-deps" ];

  nativeBuildInputs = [
    pkg-config
    open-policy-agent
    npmHooks.npmConfigHook
    nodejs
    (python3.withPackages (ps: [ ps.setuptools ])) # Used by gyp
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin cctools; # libtool used by gyp;

  buildInputs = [
    sqlite
    zstd
  ];

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
      rustTarget = stdenv.hostPlatform.rust.rustcTarget;
      rustTargetUnderscore = builtins.replaceStrings [ "-" ] [ "_" ] rustTarget;
    in
    ''
      make -C policies
      (cd "$npmRoot" && npm run build)

      # Fix aws-lc-sys cross-compilation:
      # The cc crate looks for "aarch64-linux-gnu-gcc")
      # when CC is unset and TARGET != HOST, but Nix's cross-compiler is
      # named "aarch64-unknown-linux-gnu-gcc" (with vendor).
      # We set the target-specific CC_<target> variable so the cc crate
      # and aws-lc-sys find the correct cross-compiler, then unset the
      # generic CC so aws-lc-sys doesn't misassign it.
      export CC_${rustTargetUnderscore}=$CC
      export CXX_${rustTargetUnderscore}=$CXX
      unset CC CXX
    '';

  # Adapted from https://github.com/element-hq/matrix-authentication-service/blob/v0.20.0/.github/workflows/build.yaml#L75-L84
  postInstall = ''
    install -Dm444 -t "$out/share/$pname"        "policies/policy.wasm"
    install -Dm444 -t "$out/share/$pname"        "$npmRoot/dist/manifest.json"
    install -Dm444 -t "$out/share/$pname/assets" "$npmRoot/dist/"*
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
    maintainers = with lib.maintainers; [ teutat3s ];
    mainProgram = "mas-cli";
  };
})
