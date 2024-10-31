{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdzk";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "mdzk-rs";
    repo = "mdzk";
    rev = version;
    hash = "sha256-V//tVcIzhCh03VjwMC+R2ynaOFm+dp6qxa0oqBfvGUs=";
  };

  cargoPatches = [
    # Remove when new version of mdzk is released.
    ./update-mdbook-for-rust-1.64.patch
  ];

  cargoHash = "sha256-5zGUBvmf68tCk5jGrNn+ukgYbiKzrlmZvWrYgoJf2zk=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Plain text Zettelkasten based on mdBook";
    homepage = "https://github.com/mdzk-rs/mdzk/";
    changelog = "https://github.com/mdzk-rs/mdzk/blob/main/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bryanasdev000 ratsclub ];
    mainProgram = "mdzk";
  };
}
