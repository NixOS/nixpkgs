{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "kondo";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "tbillington";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OqOmOujnyLTqwzNvLWudQi+xa5v37JTtyUXaItnpnfs=";
  };

  cargoHash = "sha256-WF4GHj/5VYrTUh1E3t29zbpSLjJ6g7RWVpLYqg9msZg=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kondo \
      --bash <($out/bin/kondo --completions bash) \
      --fish <($out/bin/kondo --completions fish) \
      --zsh <($out/bin/kondo --completions zsh)
  '';

  meta = with lib; {
    description = "Save disk space by cleaning unneeded files from software projects";
    homepage = "https://github.com/tbillington/kondo";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "kondo";
  };
}
