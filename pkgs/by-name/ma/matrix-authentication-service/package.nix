{ lib
, rustPlatform
, fetchFromGitHub
, fetchNpmDeps
, npmHooks
, nodejs
, pkg-config
, sqlite
, zstd
, stdenv
, darwin
, open-policy-agent
}:

rustPlatform.buildRustPackage rec {
  pname = "matrix-authentication-service";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-authentication-service";
    rev = "refs/tags/v${version}";
    hash = "sha256-e5JlkcSJ44iE+pVnGQpGiSNahxUcIFeaPyOjp9E3eD0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "opa-wasm-0.1.0" = "sha256-f3IIln7BbN7NJiCVMgfoell/plzlqkSm4YYK7mqzKgw=";
    };
  };

  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    src = "${src}/${npmRoot}";
    hash = "sha256-xoPclMK+io/3tx139MNyMSP0kr61XHiSzAf3YkX0YZo=";
  };

  npmRoot = "frontend";

  nativeBuildInputs = [
    pkg-config
    open-policy-agent
    npmHooks.npmConfigHook
    nodejs
  ];

  buildInputs = [
    sqlite
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
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

  # Adopted from https://github.com/matrix-org/matrix-authentication-service/blob/main/Dockerfile
  postInstall = ''
    install -Dm444 -t "$out/share/$pname"        "policies/policy.wasm"
    install -Dm444 -t "$out/share/$pname/assets" "$npmRoot/dist/"*
    cp -r templates   "$out/share/$pname/templates"
    cp -r translations   "$out/share/$pname/translations"
  '';

  meta = with lib; {
    description = "OAuth2.0 + OpenID Provider for Matrix Homeservers";
    homepage = "https://github.com/matrix-org/matrix-authentication-service";
    changelog = "https://github.com/matrix-org/matrix-authentication-service/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teutat3s ];
    mainProgram = "mas-cli";
  };
}
