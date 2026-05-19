{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  stdenv,
  apple-sdk_15,
  libiconv,
  nix-update-script,
  testers,
  chevron,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chevron";
  version = "0.5.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "shiprock";
    repo = "chevron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+2vf/OIAClDilqIkkTXcwmi8UDYIK+sMqC0ZHNOnlUA=";
  };

  cargoHash = "sha256-0MElTChJ3agjj97cJWwS87Zch5yhpItCOku/6g6PbUw=";

  # Link the system libgit2 rather than the vendored copy chevron's
  # default features pull in.
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "banner"
    "weather"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
    libiconv
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = chevron; };
  };

  meta = {
    description = "Configurable powerline prompt segments and tmux window titles for zsh, bash, and fish";
    homepage = "https://github.com/shiprock/chevron";
    changelog = "https://github.com/shiprock/chevron/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mmichie ];
    mainProgram = "chevron";
  };
})
