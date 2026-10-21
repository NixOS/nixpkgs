{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libiconv,
  stdenv,
  dbBackend ? "sqlite",
  libmysqlclient,
  libpq,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oidcwarden";
  version = "2026.4.2-1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Timshel";
    repo = "OIDCWarden";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tHacn9RtoByWpqnWX2/gWwODDSeXJa4mk4MfxHiiJ8A=";
  };

  cargoHash = "sha256-eGsYNaLYRCrTRaoyfhxnoeA2ytYeyGGvHnAbpEIayzs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ]
  ++ lib.optional (dbBackend == "mysql") libmysqlclient
  ++ lib.optional (dbBackend == "postgresql") libpq;

  buildFeatures = dbBackend;

  meta = {
    description = "Unofficial Bitwarden-compatible server with OpenID Connect support";
    homepage = "https://github.com/Timshel/OIDCWarden";
    changelog = "https://github.com/Timshel/OIDCWarden/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ DerGrumpf ];
    mainProgram = "oidcwarden";
  };
})
