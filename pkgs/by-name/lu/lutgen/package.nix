{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "lutgen";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "ozwaldorf";
    repo = "lutgen-rs";
    rev = "v${version}";
    hash = "sha256-Rj6y8ZiNWQsGn8B+iNMZvuE/U2703oYbJW+ZSdV3fl4=";
  };

  cargoHash = "sha256-7yNr6Zc5A7rj6sUnplo2gB2xNUgZ3TLwUuBEfVKZfIQ=";

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
    description = "Blazingly fast interpolated LUT generator and applicator for arbitrary and popular color palettes";
    homepage = "https://github.com/ozwaldorf/lutgen-rs";
    maintainers = with maintainers; [ zzzsy donovanglover ];
    mainProgram = "lutgen";
    license = licenses.mit;
  };
}
