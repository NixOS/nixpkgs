{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
  stdenvNoCC,
  pkg-config,
  libgit2,
  sqlite,
  zlib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu-lint";
  version = "1.9.2";

  src = fetchFromCodeberg {
    owner = "wvhulle";
    repo = "nu-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2j6ib7UkvhWRmmme/ewrqyxY1ff6FAtNpoGQyoO1/zg=";
  };

  cargoHash = "sha256-X3/aLLMXAVn7Q2EM3/I8D1tfJNq/MP1vYjoc+zSqVp0=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    # Avoids "couldn't find any valid shared libraries matching: ['libclang.dylib']" error on darwin in sandbox mode.
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libgit2
    sqlite
    zlib
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linter for the Nu shell scripting language";
    homepage = "https://codeberg.org/wvhulle/nu-lint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kpbaks
      wvhulle
    ];
    platforms = lib.platforms.all;
    mainProgram = "nu-lint";
  };
})
