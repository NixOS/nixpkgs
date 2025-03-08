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
  darwin,
  open-policy-agent,
  cctools,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "matrix-authentication-service";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "matrix-authentication-service";
    tag = "v${version}";
    hash = "sha256-s6LVCISmbG3ubY/67DcUUE/pnTJSE0v9n8INmLMQNcw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VJiIt0/zTJgCCskevb4/p62im/lAMkyJSiFUdaIdKO8=";

  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    src = "${src}/${npmRoot}";
    hash = "sha256-5Hq7wbvm3bLUSLAkLd3SNdwYCVhniV4XMCI84mO0iTc=";
  };

  npmRoot = "frontend";
  npmFlags = [ "--legacy-peer-deps" ];

  nativeBuildInputs = [
    pkg-config
    open-policy-agent
    npmHooks.npmConfigHook
    nodejs
    (python3.withPackages (ps: [ ps.setuptools ])) # Used by gyp
  ] ++ lib.optional stdenv.hostPlatform.isDarwin cctools; # libtool used by gyp;

  buildInputs =
    [
      sqlite
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk_11_0.frameworks.CoreFoundation
      darwin.apple_sdk_11_0.frameworks.Security
      darwin.apple_sdk_11_0.frameworks.SystemConfiguration
    ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  buildNoDefaultFeatures = true;

  buildFeatures = [ "dist" ];

  postPatch = ''
    substituteInPlace crates/config/src/sections/http.rs \
      --replace-fail ./frontend/dist/    "$out/share/$pname/assets/"
    substituteInPlace crates/config/src/sections/templates.rs \
      --replace-fail ./share/templates/    "$out/share/$pname/templates/" \
      --replace-fail ./share/translations/    "$out/share/$pname/translations/" \
      --replace-fail ./share/manifest.json "$out/share/$pname/assets/manifest.json"
    substituteInPlace crates/config/src/sections/policy.rs \
      --replace-fail ./share/policy.wasm "$out/share/$pname/policy.wasm"
  '';

  preBuild = ''
    make -C policies
    (cd "$npmRoot" && npm run build)
  '';

  # Adopted from https://github.com/element-hq/matrix-authentication-service/blob/main/Dockerfile
  postInstall = ''
    install -Dm444 -t "$out/share/$pname"        "policies/policy.wasm"
    install -Dm444 -t "$out/share/$pname/assets" "$npmRoot/dist/"*
    cp -r templates   "$out/share/$pname/templates"
    cp -r translations   "$out/share/$pname/translations"
  '';

  passthru = {
    tests = { inherit (nixosTests) matrix-authentication-service; };
  };

  meta = {
    description = "OAuth2.0 + OpenID Provider for Matrix Homeservers";
    homepage = "https://github.com/element-hq/matrix-authentication-service";
    changelog = "https://github.com/element-hq/matrix-authentication-service/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ teutat3s ];
    platforms = lib.platforms.linux;
    mainProgram = "mas-cli";
  };
}
