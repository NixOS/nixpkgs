{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprdim";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = "hyprdim";
    rev = version;
    hash = "sha256-Eeh0D3DkC4ureDUE+BXTGcMFNmZ0hLSidlKlL4ZDgsQ=";
  };

  cargoHash = "sha256-hgcGzRLB1L3yxJjw1ECDJPmbl1W+2OS4KDojclyVYrc=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage target/man/hyprdim.1

    installShellCompletion --cmd hyprdim \
      --bash <(cat target/completions/hyprdim.bash) \
      --fish <(cat target/completions/hyprdim.fish) \
      --zsh <(cat target/completions/_hyprdim)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Automatically dim windows in Hyprland when switching between them";
    homepage = "https://github.com/donovanglover/hyprdim";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "hyprdim";
  };
}
