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
  version = "1.4.0";
  useFetchCargoVendor = true;
  cargoHash = "sha256-7Fn68bcm8ZyR5eALCMIdcXcZ595EnWFHKdnqI5vMso4=";
  doInstallCheck = true;

  src = fetchFromGitHub {
    owner = "bootc-dev";
    repo = "bootc";
    rev = "v${version}";
    hash = "sha256-FuU3rQtKpK+ScQ10GivisSJseY2GOFJ/y2HRKIiU0G8=";
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
