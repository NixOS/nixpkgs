{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-absorb";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "tummychow";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-z02bMJ+KQaLHqIzsdB3BCVzTQ0NRG0ylAfTHYgOxZYk=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "sha256-lP0fU2Cirta4WWha7Pgje537u6TbD5oiHLfamfzJtpU=";

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
