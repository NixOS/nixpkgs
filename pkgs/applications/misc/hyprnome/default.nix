{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprnome";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "donovanglover";
    repo = "hyprnome";
    rev = version;
    hash = "sha256-zlXiT2EOIdgIDI4NQuU3C903SSq5bylBAFJXyv7mdJ4=";
  };

  cargoHash = "sha256-DpbRs97sr5wpJSrYF99ZiQ0SZOZdoQjfaLhKIAU95HA=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage target/man/hyprnome.1

    installShellCompletion --cmd hyprnome \
      --bash <(cat target/completions/hyprnome.bash) \
      --fish <(cat target/completions/hyprnome.fish) \
      --zsh <(cat target/completions/_hyprnome)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "GNOME-like workspace switching in Hyprland";
    homepage = "https://github.com/donovanglover/hyprnome";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "hyprnome";
  };
}
