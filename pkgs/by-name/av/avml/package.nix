{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  testers,
  avml,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "avml";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "avml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2oVqweq06pzFVcUVq1lCJ4rGmiZG0A7xq6g1RSwR12M=";
  };

  cargoHash = "sha256-40NKzbxNY9t5e7OJnw9Kfvx86YsPAolcezeWeFsD0C4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  passthru.tests.version = testers.testVersion { package = avml; };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Portable volatile memory acquisition tool for Linux";
    homepage = "https://github.com/microsoft/avml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lesuisse ];
    platforms = lib.platforms.linux;
    mainProgram = "avml";
  };
})
