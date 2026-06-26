{
  lib,
  stdenv,
  rustPlatform,
  fetchFromCodeberg,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mitra";
  version = "5.0.0";

  src = fetchFromCodeberg {
    owner = "silverpill";
    repo = "mitra";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Chn3SONSg6yhwwHcry/cO2L7/ihEco35gpRlMlQVXz8=";
  };

  cargoHash = "sha256-0lXwOphoUQqe1O0KbAOl98ZbMKyG8ZZOl7NhXYwSvvQ=";

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
