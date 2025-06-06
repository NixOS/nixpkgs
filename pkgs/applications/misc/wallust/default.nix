{ lib
, fetchFromGitea
, rustPlatform
, nix-update-script
, imagemagick
, makeWrapper
, installShellFiles
}:
let
  version = "3.0.0-beta";
in
rustPlatform.buildRustPackage {
  pname = "wallust";
  inherit version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "explosion-mental";
    repo = "wallust";
    rev = version;
    hash = "sha256-gGyxRdv2I/3TQWrTbUjlJGsaRv4SaNE+4Zo9LMWmxk8";
  };

  cargoHash = "sha256-dkHS8EOzmn5VLiKP3SMT0ZGAsk2wzvQeioG7NuGGUzA=";

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  postInstall = ''
    installManPage man/wallust*
    installShellCompletion --cmd wallust \
      --bash completions/wallust.bash \
      --zsh completions/_wallust \
      --fish completions/wallust.fish
  '';

  postFixup = ''
    wrapProgram $out/bin/wallust \
      --prefix PATH : "${lib.makeBinPath [ imagemagick ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Better pywal";
    homepage = "https://codeberg.org/explosion-mental/wallust";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onemoresuza iynaix ];
    downloadPage = "https://codeberg.org/explosion-mental/wallust/releases/tag/${version}";
    mainProgram = "wallust";
  };
}
