{
  lib,
  stdenv,
  rustPlatform,
  fetchFromCodeberg,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "mitra";
  version = "4.16.1";

  src = fetchFromCodeberg {
    owner = "silverpill";
    repo = "mitra";
    rev = "v${version}";
    hash = "sha256-nQhzU3LMEyqa2CciNTX5/+ViMqjmwDt3QrMZnbt/tBU=";
  };

  cargoHash = "sha256-aWBJ3PDHcqm73P4oOpuSlalT5LxRgSqhuC0f0/sL+lg=";

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
}
