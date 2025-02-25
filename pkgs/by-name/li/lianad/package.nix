{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "lianad";
  version = "9.0"; # keep in sync with liana

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = "liana";
    rev = "v${version}";
    hash = "sha256-RFlICvoePwSglpheqMb+820My//LElnSeMDPFmXyHz0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nj7L4glbjevVd1ef6RUGPm4hpzeNdnsCLC01BOJj6kI=";

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
}
