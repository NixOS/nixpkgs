{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
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

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # reqwest's native-tls-vendored feature flag uses vendored openssl. this disables that
  OPENSSL_NO_VENDOR = "1";

  # tests flaky on darwin on hydra
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Project management tool for Roblox";
    mainProgram = "rojo";
    longDescription = ''
      Rojo is a tool designed to enable Roblox developers to use professional-grade software engineering tools.
    '';
    homepage = "https://rojo.space";
    downloadPage = "https://github.com/rojo-rbx/rojo/releases/tag/v${version}";
    changelog = "https://github.com/rojo-rbx/rojo/raw/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ wackbyte ];
  };
}
