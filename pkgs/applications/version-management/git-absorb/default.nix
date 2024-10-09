{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-absorb";
  version = "0.6.15";

  src = fetchFromGitHub {
    owner = "tummychow";
    repo = "git-absorb";
    rev = "refs/tags/${version}";
    hash = "sha256-7Y/gEym+29lTwJ7FbuvOqzbiMSzrY9f5IPhtvIJUKbU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  cargoHash = "sha256-Y/0In33y4mVTaE9yoBZ/3tRWcsSKgGjTCSHdjScNEj0=";

  postInstall = ''
    installManPage Documentation/git-absorb.1
  '' + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
