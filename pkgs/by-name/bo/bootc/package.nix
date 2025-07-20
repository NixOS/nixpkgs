{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libz,
  zstd,
  pkg-config,
  openssl,
  glib,
  ostree-full,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "bootc";
  version = "1.5.0";
  useFetchCargoVendor = true;
  cargoHash = "sha256-3/Ngq6ZHPoE9BMychv+Jg0LhtJrY8GPrFYu7lRvX1+k=";
  doInstallCheck = true;

  src = fetchFromGitHub {
    owner = "bootc-dev";
    repo = "bootc";
    rev = "v${version}";
    hash = "sha256-1u4pBiySYzudFVf4bayQ7FbXf4EjA4v1+AOX9E+tjyA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libz
    zstd
    openssl
    glib
    ostree-full
  ];

  checkFlags = [
    # These all require a writable /var/tmp
    "--skip=test_cli_fns"
    "--skip=test_diff"
    "--skip=test_tar_export_reproducible"
    "--skip=test_tar_export_structure"
    "--skip=test_tar_import_empty"
    "--skip=test_tar_import_export"
    "--skip=test_tar_import_signed"
    "--skip=test_tar_write"
    "--skip=test_tar_write_tar_layer"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Boot and upgrade via container images";
    homepage = "https://bootc-dev.github.io/bootc";
    license = lib.licenses.mit;
    mainProgram = "bootc";
    maintainers = with lib.maintainers; [ thesola10 ];
    platforms = lib.platforms.linux;
  };
}
