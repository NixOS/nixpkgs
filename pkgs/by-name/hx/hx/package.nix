{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  openssl,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "hx";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "raskell-io";
    repo = "hx";
    rev = "v${version}";
    hash = "sha256-ZxICrhqR7Vs/aomv77OoZTxx6AOYg+3Qj8lTmt0Hrqs=";
  };

  cargoHash = "sha256-32jxMXgcpdKiS1+03dTh3NnVCevBLp/Fq8ddRUBogpg=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hx \
      --bash <($out/bin/hx completions generate bash) \
      --fish <($out/bin/hx completions generate fish) \
      --zsh <($out/bin/hx completions generate zsh)
  '';

  meta = {
    description = "Fast, opinionated Haskell toolchain CLI";
    longDescription = ''
      hx is a fast, batteries-included CLI for Haskell that wraps
      ghc/cabal/ghcup into a unified, user-friendly interface. It provides
      toolchain management, project initialization, building, testing,
      formatting, and diagnostics in one tool.
    '';
    homepage = "https://hx.raskell.io";
    changelog = "https://github.com/raskell-io/hx/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "hx";
  };
}
