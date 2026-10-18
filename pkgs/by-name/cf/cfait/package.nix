{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  openssl,
  cacert,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "cfait";
  version = "1.2.1";

  src = fetchFromGitea {
    domain = "git.disroot.org";
    owner = "trougnouf";
    repo = "cfait";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y5O6+bsfoNC52+YTgptfH8Rv7IORN/m2MwzXh39ofXk=";
  };

  cargoHash = "sha256-t+Ppfw+Zx1fXOksm9IXxrvR6Qoy9bhuEVGtcwrTwD00=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  meta = {
    description = "Fast, offline-first CalDAV and local task manager";
    homepage = "https://git.disroot.org/trougnouf/cfait";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ JorySeverijnse ];
    mainProgram = "cfait";
  };
})
