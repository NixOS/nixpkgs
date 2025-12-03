{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "1.6.0";

  cargoHash = "sha256-KGwXQ6+/w3uHuPqSADsqJSip+SMdC104dfW7tNxGwnc=";
  doInstallCheck = true;

  src = fetchFromGitHub {
    owner = "bootc-dev";
    repo = "bootc";
    rev = "v${version}";
    hash = "sha256-TztsiC+DwD9yEAmjTuiuOi+Kf8WEYMsOVVnMKpSM3/g=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/bootc-dev/bootc/commit/ff8b1b411270275c49ee512d54b27ed7a2fca112.patch";
      hash = "sha256-7UKquq6ZargQUDGZk22X9Co92v8e995bL+tuAjvh/7c=";
    })
  ];

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

  cargoBuildFlags = [ "-p bootc" ];

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
