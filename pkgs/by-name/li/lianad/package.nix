{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lianad";
  version = "15.0"; # keep in sync with liana

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = "liana";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mRBhpf4Risuq4TQ1y/5lWTOxN2RMHcZ2SC2BpbsOdhA=";
  };

  cargoHash = "sha256-Mr6YOK7d6pfFliaiw2Mjj5wJvPk+6yH892uS7ksd4YU=";

  buildInputs = [ udev ];

  buildAndTestSubdir = "lianad";

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
    broken = stdenv.hostPlatform.isAarch64;
  };
})
