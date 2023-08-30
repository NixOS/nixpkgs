{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "joshuto";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "kamiyaa";
    repo = "joshuto";
    rev = "v${version}";
    hash = "sha256-b13CLfWidqfYhHC9wY84kd3elsjWGxBMGr5GXHzUhfs=";
  };

  cargoHash = "sha256-gMX8hvt20V4XUd0nnXGA4fyOUfB7ZY1eeme9HgYopL0=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  postInstall = ''
    installShellCompletion --cmd joshuto \
      --bash <($out/bin/joshuto completions bash) \
      --zsh <($out/bin/joshuto completions zsh) \
      --fish <($out/bin/joshuto completions fish)
  '';

  meta = with lib; {
    description = "Ranger-like terminal file manager written in Rust";
    homepage = "https://github.com/kamiyaa/joshuto";
    changelog = "https://github.com/kamiyaa/joshuto/releases/tag/${src.rev}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ figsoda totoroot xrelkd ];
    mainProgram = "joshuto";
  };
}
