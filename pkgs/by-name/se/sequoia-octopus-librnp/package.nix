{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  bzip2,
  libgit2,
  nettle,
  openssl,
  sqlite,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sequoia-octopus-librnp";
  version = "1.11.1";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-octopus-librnp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D10Nt+fV/zGt5YBEBoFI3z0TbLSnRWgzTO+MmLtfQe0=";
  };

  cargoHash = "sha256-o+3urC4k1gjfm35027KABAotV5HrBp6qJUNPM5kM8Vs=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    bzip2
    libgit2
    nettle
    openssl
    sqlite
    zlib
  ];

  meta = {
    description = "";
    homepage = "https://gitlab.com/sequoia-pgp/sequoia-octopus-librnp";
    changelog = "https://gitlab.com/sequoia-pgp/sequoia-octopus-librnp/-/blob/${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
