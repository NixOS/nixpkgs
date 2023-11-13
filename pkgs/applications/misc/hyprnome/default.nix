{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprnome";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = "hyprnome";
    rev = version;
    hash = "sha256-jb21hnPSzrCTuW7Yhs6jFzS2WUVQjkn6nCCi6LvoTGA=";
  };

  cargoHash = "sha256-QM5v2hKP3E9W3Aek6kFyFFNAp9s0oTFb4CEtxEHyny0=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage man/hyprnome.1

    installShellCompletion --cmd hyprnome \
      --bash <(cat completions/hyprnome.bash) \
      --fish <(cat completions/hyprnome.fish) \
      --zsh <(cat completions/_hyprnome)
  '';

  meta = with lib; {
    description = "GNOME-like workspace switching in Hyprland";
    homepage = "https://github.com/donovanglover/hyprnome";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "hyprnome";
  };
}
