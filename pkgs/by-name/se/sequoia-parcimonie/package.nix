{
  lib,
  rustPlatform,
  fetchFromGitLab,
  openssl,
  nettle,
  sqlite,
  pkg-config,
}:
rustPlatform.buildRustPackage (final: {
  pname = "sequoia-parcimonie";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-parcimonie";
    tag = "v${final.version}";
    hash = "sha256-zWwIpzfyuF8dcO5g41HEyeHJY1MKykdwbdOkQ5tdqq0=";
  };

  cargoHash = "sha256-r8HvObNbAmM0hWEti/QSsBi0F1Pp5pCtTmHw5pZm580=";

  buildInputs = [
    openssl.dev
    nettle.dev
    sqlite.dev
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  __structuredAttrs = true;

  meta = {
    homepage = "https://gitlab.com/sequoia-pgp/sequoia-parcimonie";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "sq-parcimonie";
  };
})
