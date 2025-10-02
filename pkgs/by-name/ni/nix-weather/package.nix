{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  libiconv,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-weather";
  version = "0.0.4";

  # fetch from GitHub and not upstream forgejo because cafkafk doesn't want to
  # pay for bandwidth
  src = fetchFromGitHub {
    owner = "cafkafk";
    repo = "nix-weather";
    rev = "v${version}";
    hash = "sha256-15FUA4fszbAVXop3IyOHfxroyTt9/SkWZsSTUh9RtwY=";
  };

  cargoHash = "sha256-IkwCa+MioL2F3fiUYm3HQOeO2yb+58YQzM9YJ2oILj4=";
  cargoExtraArgs = "-p nix-weather";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  outputs = [
    "out"
    "man"
  ];

  # This is where `build.rs` puts manpages
  MAN_OUT = "./man";

  postInstall = ''
    cd crates/nix-weather
    installManPage man/nix-weather.1
    installShellCompletion \
      --fish man/nix-weather.fish \
      --bash man/nix-weather.bash \
      --zsh  man/_nix-weather
    mkdir -p $out
    cd ../..
  '';

  # We are the only distro that will ever package this, thus ryanbot will not
  # be able to find updates through repology and we need this.
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Check Cache Availablility of NixOS Configurations";
    longDescription = ''
      Fast rust tool to check availability of your entire system in caches. It
      so to speak "checks the weather" before going to update. Useful for
      debugging cache utilization and timing updates and deployments.

      Heavily inspired by guix weather.
    '';
    homepage = "https://git.fem.gg/cafkafk/nix-weather";
    changelog = "https://git.fem.gg/cafkafk/nix-weather/releases/tag/v${version}";
    license = lib.licenses.eupl12;
    mainProgram = "nix-weather";
    maintainers = with lib.maintainers; [
      cafkafk
      freyacodes
    ];
    platforms = lib.platforms.all;
  };
}
