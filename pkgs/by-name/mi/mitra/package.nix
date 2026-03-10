{
  lib,
  stdenv,
  rustPlatform,
  fetchFromCodeberg,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mitra";
  version = "4.17.0";

  src = fetchFromCodeberg {
    owner = "silverpill";
    repo = "mitra";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ysV0r0K+2ivnDg/GuqwK5HWa4/jQtopXqS9g/9wWrOw=";
  };

  cargoHash = "sha256-RDMLfg+KsvfXDjsCzCn53kebBRN8/6er/LsS/BzoeU0=";

  # require running database
  doCheck = false;

  env.RUSTFLAGS = toString [
    # MEMO: mitra use ammonia crate with unstable rustc flag
    "--cfg=ammonia_unstable"
  ];

  buildFeatures = [
    "production"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mitra \
      --bash <($out/bin/mitra completion --shell bash) \
      --fish <($out/bin/mitra completion --shell fish) \
      --zsh <($out/bin/mitra completion --shell zsh)
  '';

  meta = {
    description = "Federated micro-blogging platform";
    homepage = "https://codeberg.org/silverpill/mitra";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "mitra";
  };
})
