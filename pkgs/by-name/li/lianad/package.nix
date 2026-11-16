{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  udev,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lianad";
  version = "16.0"; # keep in sync with liana

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = "liana";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ksY9wzjOrGaxfPqC3JDWS/VRA6PveysAVgKpA1YGNLw=";
  };

  cargoHash = "sha256-zz0hqOrk74FD2ct4LIDJJJRNxwR/6OXk3PUJFBYX0AA=";

  buildInputs = [
    udev
    sqlite
  ];

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
