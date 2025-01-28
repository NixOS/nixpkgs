{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  qemu,
}:

rustPlatform.buildRustPackage rec {
  version = "9.1.3";
  pname = "oxipng";

  # do not use fetchCrate (only repository includes tests)
  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = "oxipng";
    tag = "v${version}";
    hash = "sha256-8EOEcIw10hCyYi9SwDLDZ8J3ezLXa30RUY5I9ksfqTs=";
  };

  cargoHash = "sha256-4PCLtBJliK3uteL8EVKLBVR2YZW1gwQOiSLQok+rqug=";

  # See https://github.com/shssoichiro/oxipng/blob/14b8b0e93a/.cargo/config.toml#L5
  nativeCheckInputs = [ qemu ];

  meta = {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "Multithreaded lossless PNG compression optimizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dywedir ];
    mainProgram = "oxipng";
  };
}
