{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-absorb";
  version = "0.6.11";

  src = fetchFromGitHub {
    owner = "tummychow";
    repo = "git-absorb";
    rev = "refs/tags/${version}";
    hash = "sha256-SYBJKnzv2oktWubgm/j6wEeoLSBjGqQVXQf9LOaq+NU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoHash = "sha256-i2ntM7NTi+hiB7DxEEV+3SXV8sVVWcNanif/wUZ9XvI=";

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
