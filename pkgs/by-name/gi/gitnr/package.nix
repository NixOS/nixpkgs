{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  openssl,
  stdenv,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitnr";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "reemus-dev";
    repo = "gitnr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Bxr8NwUUDLHbAzGbS5S89StzXTZ88qa2TuO8zxYVkAg=";
  };

  cargoHash = "sha256-cSvcVe1v9tRxXb4rm2Hfr0K5RhLjLgGPjdfc1VCh3co=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libxkbcommon
    wayland
  ];

  # requires internet access
  doCheck = false;

  meta = {
    description = "Create `.gitignore` files using one or more templates from TopTal, GitHub or your own collection";
    homepage = "https://github.com/reemus-dev/gitnr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "gitnr";
  };
})
