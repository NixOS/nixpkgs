{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-absorb";
  version = "0.6.17";

  src = fetchFromGitHub {
    owner = "tummychow";
    repo = "git-absorb";
    tag = version;
    hash = "sha256-wtXqJfI/I0prPip3AbfFk0OvPja6oytPsl6hFtZ6b50=";
  };

  nativeBuildInputs = [ installShellFiles ];

  cargoHash = "sha256-R9hh696KLoYUfJIe3X4X1VHOpPmv1fhZ55y8muVAdRI=";

  postInstall =
    ''
      installManPage Documentation/git-absorb.1
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
