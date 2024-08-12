{
  lib,
  rustPlatform,
  fetchFromGitHub,
  substituteAll,
  perl,
  stdenv,
  CoreServices,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "kakoune-lsp";
  version = "17.0.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uXKquAjfytUn/Q0kx+0BGRQTkVMQ9rMRnTCy622upag=";
  };

  patches = [
    (substituteAll {
      src = ./Hardcode-perl.patch;
      perl = lib.getExe perl;
    })
  ];

  cargoHash = "sha256-XnhYODMzqInwbgM8wveY048sljZ8OKw4hLYJG5h8Twc=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    Security
    SystemConfiguration
  ];

  meta = {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/kakoune-lsp/kakoune-lsp";

    # See https://github.com/kakoune-lsp/kakoune-lsp/commit/55dfc83409b9b7d3556bacda8ef8b71fc33b58cd
    license = with lib.licenses; [
      unlicense
      mit
    ];

    maintainers = with lib.maintainers; [
      philiptaron
      spacekookie
      poweredbypie
    ];

    mainProgram = "kak-lsp";
  };
}
