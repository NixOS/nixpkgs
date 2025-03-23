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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "tummychow";
    repo = "git-absorb";
    tag = version;
    hash = "sha256-fn4xeXlYl8xB/wjpt7By9tATzb5t58jcuwfqw0tNH7M=";
  };

  nativeBuildInputs = [
    asciidoc
    installShellFiles
    which # used by Documentation/Makefile
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-PC040PtMK0OUS4zlLoHPcSzgEw5H3kndnVuyME/jEz4=";

  nativeCheckInputs = [
    gitMinimal
  ];

  postInstall =
    ''
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
      tomfitzhenry
      matthiasbeyer
    ];
    mainProgram = "git-absorb";
  };
}
