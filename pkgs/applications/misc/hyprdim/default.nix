{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprdim";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = pname;
    rev = version;
    hash = "sha256-6HeVLgEJDPy4cWL5td3Xl7+a6WUFZWUFynvBzPhItcg=";
  };

  cargoHash = "sha256-qYX5o64X8PsFcTYuZ82lIShyUN69oTzQIHrQH4B7iIw=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage man/hyprdim.1

    installShellCompletion --cmd hyprdim \
      --bash <(cat completions/hyprdim.bash) \
      --fish <(cat completions/hyprdim.fish) \
      --zsh <(cat completions/_hyprdim)
  '';

  meta = with lib; {
    description = "Automatically dim windows in Hyprland when switching between them";
    homepage = "https://github.com/donovanglover/hyprdim";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "hyprdim";
  };
}
