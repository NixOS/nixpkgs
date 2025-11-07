{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  nix-update-script,
  openssl,
}:

let
  pname = "gptcommit";
  version = "0.5.17";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "zurawiki";
    repo = "gptcommit";
    rev = "v${version}";
    hash = "sha256-MB78QsJA90Au0bCUXfkcjnvfPagTPZwFhFVqxix+Clw=";
  };

  cargoHash = "sha256-PFpc9z45k0nlWEyjDDKG/U8V7EwR5b8rHPV4CmkRers=";

  nativeBuildInputs = [ pkg-config ];

  # 0.5.6 release has failing tests
  doCheck = false;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Git prepare-commit-msg hook for authoring commit messages with GPT-3";
    mainProgram = "gptcommit";
    homepage = "https://github.com/zurawiki/gptcommit";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
    platforms = with platforms; all;
  };
}
