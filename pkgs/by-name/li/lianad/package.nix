{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lianad";
  version = "14.0"; # keep in sync with liana

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = "liana";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1d+icjk1NamlvEx4Xb1Ao4d1hb/t5aBwho+yCtHF9y4=";
  };

  cargoHash = "sha256-9CWJIRby6QWJmkYSHj2lFfEj0plX5iWxsdQs5sYww7Q=";

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
