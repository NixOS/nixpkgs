{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  systemd,
}:

rustPlatform.buildRustPackage rec {
  pname = "lianad";
  version = "5.0"; # keep in sync with liana

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = "liana";
    rev = "v${version}";
    hash = "sha256-RkZ2HSN7IjwN3tD0UhpMeQeqkb+Y79kSWnjJZ5KPbQk=";
  };

  cargoHash = "sha256-6r8G4sO/aDO5VyJbmbdFz3W2b8ZmulXJZtnz8IAwcaU=";

  buildInputs = [ systemd ];

  postInstall = ''
    install -Dm0644 ./contrib/lianad_config_example.toml $out/etc/liana/config.toml
  '';

  # bypass broken unit tests
  doCheck = false;

  meta = {
    mainProgram = "lianad";
    description = "Bitcoin wallet leveraging on-chain timelocks for safety and recovery";
    homepage = "https://wizardsardine.com/liana";
    license = lib.licenses.bsd3;
    maintainers = [
      lib.maintainers.dunxen
      lib.maintainers.plebhash
    ];
    platforms = lib.platforms.linux;
    broken = stdenv.isAarch64;
  };
}
