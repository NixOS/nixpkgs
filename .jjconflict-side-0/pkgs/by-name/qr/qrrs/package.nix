{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  pname = "qrrs";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "lenivaya";
    repo = "qrrs";
    rev = "v${version}";
    hash = "sha256-L8sqvLbh85b8Ds9EvXNkyGVXm8BF3ejFd8ZH7QoxJdU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/aRr5UeGKGt+H9+C9MWcpMriPeIVEwp7xnigrUvMUiw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ./man/*.?


    installShellCompletion --cmd qrrs \
      --bash <(cat ./completions/qrrs.bash) \
      --fish <(cat ./completions/qrrs.fish) \
      --zsh <(cat ./completions/_qrrs)
  '';

  meta = with lib; {
    maintainers = with maintainers; [ lenivaya ];
    description = "CLI QR code generator and reader written in rust";
    license = licenses.mit;
    homepage = "https://github.com/Lenivaya/qrrs";
    mainProgram = "qrrs";
  };
}
