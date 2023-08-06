{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprdim";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = pname;
    rev = version;
    hash = "sha256-EJ+3rmfRJOt9xiuWlR5IBoEzChwp35CUum25lYnFY14=";
  };

  cargoHash = "sha256-Pd7dM+PPI0mwxbdfTu+gZ0tScZDGa2vGqEwuj8gW1Sk=";

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
