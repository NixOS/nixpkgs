{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-absorb";
  version = "0.6.13";

  src = fetchFromGitHub {
    owner = "tummychow";
    repo = "git-absorb";
    rev = "refs/tags/${version}";
    hash = "sha256-k0smjIpy/+y6M5p24Ju4CVJkThzWOgp5kBJuVnCrXiE=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoHash = "sha256-bRPdtiC9Dwi21g4WtjawQ2AUdizUEX2zPHAnG08D3ac=";

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
    maintainers = with maintainers; [ tomfitzhenry ];
    mainProgram = "git-absorb";
  };
}
