{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "octofetch";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "azur1s";
    repo = "octofetch";
    rev = finalAttrs.version;
    sha256 = "sha256-/AXE1e02NfxQzJZd0QX6gJDjmFFmuUTOndulZElgIMI=";
  };

  cargoHash = "sha256-1lnHCiRktBGYb7Bgq4p60+kikb/LApPhzNp1O0Go46Q=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  meta = {
    homepage = "https://github.com/azur1s/octofetch";
    description = "Github user information on terminal";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "octofetch";
  };
})
