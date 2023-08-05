{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprdim";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = pname;
    rev = version;
    hash = "sha256-0FSviEaKANTHBZa12NbNKnOfcbXQLQzJBGMDruq71+g=";
  };

  cargoHash = "sha256-eNtieSj4tr5CeH4BDclkp41QGQLkjYgLXil7sXQcfdU=";

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
  };
}
