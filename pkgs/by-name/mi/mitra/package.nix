{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitea,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "mitra";
  version = "4.15.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "silverpill";
    repo = "mitra";
    rev = "v${version}";
    hash = "sha256-zEJ+fGOY69F/gF7ZFyWigAxTXP6sZMvFo7sgy36wVFk=";
  };

  cargoHash = "sha256-DQAqvh17AWQt3gSRzQlP5ZL3L1Euqsl+bXoiJBGkdqo=";

  # require running database
  doCheck = false;

  RUSTFLAGS = [
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
