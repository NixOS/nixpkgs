{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "ab-av1";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "alexheretic";
    repo = "ab-av1";
    tag = "v${version}";
    hash = "sha256-bVsEsQMQhXyDES5mlBHRK1Uf7UwbX6iKhTF17peokAk=";
  };

  cargoHash = "sha256-TDpNT62jkkP+g2w1HXmPJiblHXFOuAuzYRY5cpzRW/M=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ab-av1 \
      --bash <($out/bin/ab-av1 print-completions bash) \
      --fish <($out/bin/ab-av1 print-completions fish) \
      --zsh <($out/bin/ab-av1 print-completions zsh)
  '';

  meta = {
    description = "AV1 re-encoding using ffmpeg, svt-av1 & vmaf";
    homepage = "https://github.com/alexheretic/ab-av1";
    changelog = "https://github.com/alexheretic/ab-av1/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ab-av1";
  };
}
