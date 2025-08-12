{
  lib,
  stdenv,
  asciidoc,
  fetchFromGitHub,
  gitMinimal,
  rustPlatform,
  installShellFiles,
  which,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-absorb";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "tummychow";
    repo = "git-absorb";
    tag = version;
    hash = "sha256-O9bJMYhIyCtztswvL0JQ4ZtsAAI9TlHzWDeGdTHEmP4=";
  };

  nativeBuildInputs = [
    asciidoc
    installShellFiles
    which # used by Documentation/Makefile
  ];

  cargoHash = "sha256-QBZItmKH9b2KwHR88MotyIT2krZl5QQFLvUmPmbxl4U=";

  nativeCheckInputs = [
    gitMinimal
  ];

  postInstall = ''
    cd Documentation/
    make
    installManPage git-absorb.1
    cd -
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd git-absorb \
      --bash <($out/bin/git-absorb --gen-completions bash) \
      --fish <($out/bin/git-absorb --gen-completions fish) \
      --zsh <($out/bin/git-absorb --gen-completions zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/tummychow/git-absorb";
    description = "git commit --fixup, but automatic";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [
      matthiasbeyer
    ];
    mainProgram = "git-absorb";
  };
}
