{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
  zstd,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lonkero";
  version = "3.7.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bountyyfi";
    repo = "lonkero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kgior5JHLTcGdjYNxNvtQpJWPY6a7vEtl8qBuZuzKbc=";
  };

  cargoHash = "sha256-do4GTrSXfdtKFpauL5MdFMrKMLJ3Ol0wIz2cr16pimQ=";

  postPatch = ''
    substituteInPlace src/cli/main.rs \
      --replace-fail "3.5.0" "${finalAttrs.version}"
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    zlib
    zstd
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    DO_NOT_FORMAT = "true";
  };

  doCheck = false;

  meta = {
    description = "Scanner for penetration testing";
    homepage = "https://github.com/bountyyfi/lonkero";
    changelog = "https://github.com/bountyyfi/lonkero/releases/tag/${finalAttrs.src.tag}";
    license = {
      fullName = "Bountyy Source-Available License 2.1";
      shortName = "lonkero-source-available";
      url = "https://github.com/bountyyfi/lonkero/blob/main/LICENSE";
      free = false;
      redistributable = false;
    };
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "lonkero";
  };
})
