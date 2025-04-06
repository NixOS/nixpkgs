{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "lianad";
  version = "10.0"; # keep in sync with liana

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = "liana";
    rev = "v${version}";
    hash = "sha256-nuwbJxpcapk01qwGAZ2z9nKjHNqE1BMikz3hWrCAGsA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-tODnld6V2KWarfHXyoPjSGw+q1A/dalPtW3Swc2dNes=";

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
