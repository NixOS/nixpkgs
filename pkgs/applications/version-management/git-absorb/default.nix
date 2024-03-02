{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-absorb";
  version = "0.6.12";

  src = fetchFromGitHub {
    owner = "tummychow";
    repo = "git-absorb";
    rev = "refs/tags/${version}";
    hash = "sha256-yHCO1v1d0MUakae16fFVvtKG3rVxU/Cii/G6IKzyebA=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoHash = "sha256-Bx7gH7jSLizG95JyBtziPBby9mF1Nj3CQexIg6gaiM0=";

  postInstall = ''
    installManPage Documentation/git-absorb.1
    installShellCompletion --cmd git-absorb \
      --bash <($out/bin/git-absorb --gen-completions bash) \
      --fish <($out/bin/git-absorb --gen-completions fish) \
      --zsh <($out/bin/git-absorb --gen-completions zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/tummychow/git-absorb";
    description = "git commit --fixup, but automatic";
    license = [ licenses.bsd3 ];
    maintainers = [ maintainers.marsam ];
    mainProgram = "git-absorb";
  };
}
