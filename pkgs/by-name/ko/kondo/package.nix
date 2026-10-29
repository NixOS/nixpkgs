{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kondo";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "tbillington";
    repo = "kondo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lbj1usgwfp7IiCNPtmHSHvX3ARGY5UpJYT89U3+kTuk=";
  };

  cargoHash = "sha256-IrUUAz4XEw3rxj8SuWMvBZu9pzCxOm5NZfiWp8i8MMo=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kondo \
      --bash <($out/bin/kondo --completions bash) \
      --fish <($out/bin/kondo --completions fish) \
      --zsh <($out/bin/kondo --completions zsh)
  '';

  meta = {
    description = "Save disk space by cleaning unneeded files from software projects";
    homepage = "https://github.com/tbillington/kondo";
    license = lib.licenses.mit;
    mainProgram = "kondo";
  };
})
