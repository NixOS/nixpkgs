{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  aws-lc,
  cacert,
  libiconv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "monolith";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "Y2Z";
    repo = "monolith";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YBfKqOX4auA3+LCq5aKfPNBmmVVCJHJI1H6lCw1g6O4=";
  };

  cargoHash = "sha256-oHHNDcZUqEgKGrHxADgjVMKpXdcpOH84NaKUDiX0FM4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    aws-lc
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeCheckInputs = [ cacert ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bundle any web page into a single HTML file";
    mainProgram = "monolith";
    homepage = "https://github.com/Y2Z/monolith";
    license = lib.licenses.cc0;
    platforms = lib.platforms.unix;
  };
})
