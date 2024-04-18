{
  darwin,
  fetchFromGitHub,
  lib,
  libiconv,
  pkg-config,
  rustPlatform,
  sqlite,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "rippkgs";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "replit";
    repo = "rippkgs";
    rev = "v${version}";
    hash = "sha256-qQZnD9meczfsQv1R68IiUfPq730I2IyesurrOhtA3es=";
  };

  cargoHash = "sha256-hGSHgJ2HVCNqTBsTQIZlSE89FKqdMifuJyAGl3utF2I=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "A CLI for indexing and searching packages in Nix expressions";
    homepage = "https://github.com/replit/rippkgs";
    license = with licenses; [ mit ];
    mainProgram = "rippkgs";
    maintainers = with maintainers; [ cdmistman ];
  };
}
