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
}:

rustPlatform.buildRustPackage rec {
  pname = "matrix-authentication-service";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "matrix-authentication-service";
    tag = "v${version}";
    hash = "sha256-rFex6stw++xNrcCYnYn3N0HrUQd91DAw9QU0R2MUzyQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-u3C6JmaPU4/pyg8Ko01Y33UkuqrVa2lV/jYdMUAF6ng=";

  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    src = "${src}/${npmRoot}";
    hash = "sha256-4tFE7za2bBOCtX0fSaLvvyD4UTGtvtJlgO30lHCv07Y=";
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
      --replace ./frontend/dist/    "$out/share/$pname/assets/"
    substituteInPlace crates/config/src/sections/templates.rs \
      --replace ./share/templates/    "$out/share/$pname/templates/" \
      --replace ./share/translations/    "$out/share/$pname/translations/" \
      --replace ./share/manifest.json "$out/share/$pname/assets/manifest.json"
    substituteInPlace crates/config/src/sections/policy.rs \
      --replace ./share/policy.wasm "$out/share/$pname/policy.wasm"
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

  meta = {
    description = "OAuth2.0 + OpenID Provider for Matrix Homeservers";
    homepage = "https://github.com/element-hq/matrix-authentication-service";
    changelog = "https://github.com/element-hq/matrix-authentication-service/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ teutat3s ];
    mainProgram = "mas-cli";
  };
}
