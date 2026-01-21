{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "genact";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "genact";
    rev = "v${version}";
    sha256 = "sha256-6d8p+Hon9zZMNRLX9+eBB3K5PffsX7w5PcbIiesCvSc=";
  };

  cargoHash = "sha256-umb+hf61k/sSfPVUCS1qJ0p+NLfjgZffuEWoQj1NIVY=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/genact --print-manpage > genact.1
    installManPage genact.1

    installShellCompletion --cmd genact \
      --bash <($out/bin/genact --print-completions bash) \
      --fish <($out/bin/genact --print-completions fish) \
      --zsh <($out/bin/genact --print-completions zsh)
  '';

  meta = {
    description = "Nonsense activity generator";
    homepage = "https://github.com/svenstaro/genact";
    changelog = "https://github.com/svenstaro/genact/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "genact";
  };
}
