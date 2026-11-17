{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
  nix-update-script,
  pkg-config,
  openssl,
  sqlite,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ockam";
  version = "0.157.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "build-trust";
    repo = "ockam";
    rev = "ockam_v${finalAttrs.version}";
    hash = "sha256-o895VPlUGmLUsIeOnShjCetKoS/4x0nbEKxipEbuBu4=";
  };

  cargoHash = "sha256-hHbMMi4nuTORUPEKEo3OiQg7y12+cXHzUAkh3ApYx5s=";

  # sqlx < 0.8.4 opens in-memory databases without SQLITE_OPEN_URI, so with the
  # system SQLite every pooled connection gets its own empty database.
  # https://github.com/launchbadge/sqlx/pull/3289
  postPatch = ''
    substituteInPlace $cargoDepsCopy/*/sqlx-sqlite-*/src/connection/establish.rs \
      --replace-fail 'flags |= SQLITE_OPEN_MEMORY;' 'flags |= SQLITE_OPEN_MEMORY | libsqlite3_sys::SQLITE_OPEN_URI;'
  '';

  nativeBuildInputs = [
    git
    pkg-config
  ];
  buildInputs = [
    openssl
    sqlite
    dbus
  ];

  passthru.updateScript = nix-update-script { };

  # too many tests fail for now
  doCheck = false;

  cargoBuildFlags = [ "--package=ockam" ];

  meta = {
    description = "Orchestrate end-to-end encryption, cryptographic identities, mutual authentication, and authorization policies between distributed applications – at massive scale";
    homepage = "https://github.com/build-trust/ockam";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
