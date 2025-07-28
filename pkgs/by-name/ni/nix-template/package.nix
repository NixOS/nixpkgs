{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  nix,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-template";
  version = "0.4.1";

  src = fetchFromGitHub {
    name = "${pname}-${version}-src";
    owner = "jonringer";
    repo = "nix-template";
    rev = "v${version}";
    sha256 = "sha256-42u5FmTIKHpfQ2zZQXIrFkAN2/XvU0wWnCRrQkQzcNI=";
  };

  cargoHash = "sha256-cLSGWOyBQLv235TeYqSVg/f0Zmcnpj+RshINN69JYEU=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];

  buildInputs = [ openssl ];

  # needed for nix-prefetch-url
  postInstall = ''
    wrapProgram $out/bin/nix-template \
      --prefix PATH : ${lib.makeBinPath [ nix ]}

  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd nix-template \
      --bash <($out/bin/nix-template completions bash) \
      --fish <($out/bin/nix-template completions fish) \
      --zsh <($out/bin/nix-template completions zsh)
  '';

  meta = {
    description = "Make creating nix expressions easy";
    homepage = "https://github.com/jonringer/nix-template/";
    changelog = "https://github.com/jonringer/nix-template/releases/tag/v${version}";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "nix-template";
  };
}
