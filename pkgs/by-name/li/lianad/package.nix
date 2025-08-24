{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "lianad";
  version = "12.0"; # keep in sync with liana

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = "liana";
    rev = "v${version}";
    hash = "sha256-TZUNYr7p4P/++eX9ZNU/d1IurPrkZn/PJmJOsB01VMY=";
  };

  cargoHash = "sha256-Hb5icOKgQiDzFLWwUfkwXcr1vn80QcAr+fKwG37PkYc=";

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
