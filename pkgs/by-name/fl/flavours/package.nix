{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "flavours";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Misterio77";
    repo = "flavours";
    rev = "v${version}";
    hash = "sha256-SOsHvcfDdUpb0x5VZ1vZJnGaIiWWOPgnAwKYNXzfUfI=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  cargoHash = "sha256-9/2kiLuIyErwZ1O9457WkYbwlsbPY3P8wlH2hW0W1xU=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd flavours \
      --zsh <($out/bin/flavours --completions zsh) \
      --fish <($out/bin/flavours --completions fish) \
      --bash <($out/bin/flavours --completions bash)
  '';

  meta = {
    description = "Easy to use base16 scheme manager/builder that integrates with any workflow";
    homepage = "https://github.com/Misterio77/flavours";
    changelog = "https://github.com/Misterio77/flavours/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      moni
      misterio77
    ];
    mainProgram = "flavours";
  };
}
