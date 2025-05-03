{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "rojo";
  version = "7.5.0";

  src = fetchFromGitHub {
    owner = "rojo-rbx";
    repo = "rojo";
    rev = "v${version}";
    hash = "sha256-aCwQ07z7MhBS4C03npwjQOmfJXwD7trYo/upT3GAkHU=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-naItqyJaIxFZuswbrE8RZqMffGy1MaIa0RX9RLOWmyw=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # reqwest's native-tls-vendored feature flag uses vendored openssl. this disables that
  OPENSSL_NO_VENDOR = "1";

  # tests flaky on darwin on hydra
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    changelog = "https://github.com/rojo-rbx/rojo/blob/v${version}/CHANGELOG.md";
    description = "Project management tool for Roblox";
    downloadPage = "https://github.com/rojo-rbx/rojo/releases/tag/v${version}";
    homepage = "https://rojo.space";
    license = lib.licenses.mpl20;
    longDescription = ''
      Tool designed to enable Roblox developers to use professional-grade software engineering tools.
    '';
    mainProgram = "rojo";
    maintainers = with lib.maintainers; [ wackbyte ];
  };
}
