{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "ab-av1";
<<<<<<< HEAD
  version = "0.10.3";
=======
  version = "0.10.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "alexheretic";
    repo = "ab-av1";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-HSWu3gHpgCUkmr63mAi2Hd67Rap5vDZ/oHRh6O7y6uA=";
  };

  cargoHash = "sha256-jzEwblYsA7tgoJE6HhdtdDyOS50DyL87/J/T+cNKB3M=";
=======
    hash = "sha256-bVsEsQMQhXyDES5mlBHRK1Uf7UwbX6iKhTF17peokAk=";
  };

  cargoHash = "sha256-TDpNT62jkkP+g2w1HXmPJiblHXFOuAuzYRY5cpzRW/M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
