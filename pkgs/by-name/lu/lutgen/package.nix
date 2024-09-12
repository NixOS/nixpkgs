{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "lutgen";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "ozwaldorf";
    repo = "lutgen-rs";
    rev = "v${version}";
    hash = "sha256-ybaapL9OUUQ+sO8P0JH1MuxCFmTihKp9gXJpM7KLY7U=";
  };

  cargoHash = "sha256-Fxecnq7QKcDe6aAsKj9uye3sFdfkgFEKYmdqnvQDiAQ=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lutgen \
      --bash <($out/bin/lutgen --bpaf-complete-style-bash) \
      --fish <($out/bin/lutgen --bpaf-complete-style-fish) \
      --zsh <($out/bin/lutgen --bpaf-complete-style-zsh)
  '';

  meta = with lib; {
    description = "Blazingly fast interpolated LUT generator and applicator for arbitrary and popular color palettes";
    homepage = "https://github.com/ozwaldorf/lutgen-rs";
    maintainers = with maintainers; [
      ozwaldorf
      zzzsy
      donovanglover
    ];
    mainProgram = "lutgen";
    license = licenses.mit;
  };
}
