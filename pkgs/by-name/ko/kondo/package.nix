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
    repo = "kondo";
    rev = "v${version}";
    hash = "sha256-OqOmOujnyLTqwzNvLWudQi+xa5v37JTtyUXaItnpnfs=";
  };

  cargoHash = "sha256-jmN7mtQ3CXfyeYrYD+JBE6ppln8+VJRBzygmczo8M04=";

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
    mainProgram = "kondo";
  };
}
