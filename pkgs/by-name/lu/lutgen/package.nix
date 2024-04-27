{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "lutgen";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ozwaldorf";
    repo = "lutgen-rs";
    rev = "v${version}";
    hash = "sha256-O2995+DLiCRDM/+oPTOBiM0L1x0jmbLTlR48+5IfOQw=";
  };

  cargoHash = "sha256-ys4c/YUJJikDEUJjzagZBB+kSy+EFf+PqQdK/h+3gWU=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lutgen \
      --bash <($out/bin/lutgen completions bash) \
      --fish <($out/bin/lutgen completions fish) \
      --zsh <($out/bin/lutgen completions zsh)
  '';

  meta = with lib; {
    description = "A blazingly fast interpolated LUT generator and applicator for arbitrary and popular color palettes";
    homepage = "https://github.com/ozwaldorf/lutgen-rs";
    maintainers = with maintainers; [ zzzsy donovanglover ];
    mainProgram = "lutgen";
    license = licenses.mit;
  };
}
