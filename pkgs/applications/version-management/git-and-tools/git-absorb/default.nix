{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-absorb";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "tummychow";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-qhUw1wjXn1tyiH175+BadcoKoZ0wHxpMTKDIKOcJjQ0=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "sha256-Wh2kA12CggbgdofWJwPAy+587qfMUPSy9nQmO11+keY=";

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
  };
}
