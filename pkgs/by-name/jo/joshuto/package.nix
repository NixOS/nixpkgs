{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "joshuto";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "kamiyaa";
    repo = "joshuto";
    rev = "v${version}";
    hash = "sha256-hfu3Verbrq0to3I5/gX6ZhVr7ewjHNamzvaUcmcUIRU=";
  };

  cargoHash = "sha256-K/++/NdOLSvhxQ8LBS+jnthCRJxScoOjWSp7pmfHVaQ=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd joshuto \
      --bash <($out/bin/joshuto completions bash) \
      --zsh <($out/bin/joshuto completions zsh) \
      --fish <($out/bin/joshuto completions fish)
  '';

  meta = with lib; {
    description = "Ranger-like terminal file manager written in Rust";
    homepage = "https://github.com/kamiyaa/joshuto";
    changelog = "https://github.com/kamiyaa/joshuto/releases/tag/${src.rev}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      totoroot
      xrelkd
    ];
    mainProgram = "joshuto";
  };
}
