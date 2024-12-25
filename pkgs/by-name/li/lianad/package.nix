{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "lianad";
  version = "8.0"; # keep in sync with liana

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = "liana";
    rev = "v${version}";
    hash = "sha256-2aIaRZNIRgFdA+NVnzOkEE3kYA15CoNBrsNGBhIz0nU=";
  };

  cargoHash = "sha256-/EkDAZPNka+vRWsAo4i/65lufUu8N/m8cfBsOInjaxQ=";

  buildInputs = [ udev ];

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
}
