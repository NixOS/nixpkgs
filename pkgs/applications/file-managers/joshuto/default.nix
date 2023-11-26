{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "joshuto";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "kamiyaa";
    repo = "joshuto";
    rev = "v${version}";
    hash = "sha256-d2r8xPGnH/299wjEijilgqy3u/xJgtRmwzJdHt0sA+o=";
  };

  cargoHash = "sha256-amgqoL7NYfl3WzTtgvDoBX46rsL9248rbCis6MHVQhE=";

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
