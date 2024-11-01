{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libz,
  zstd,
  pkg-config,
  openssl,
  glib,
  ostree,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "bootc";
  version = "1.1.0";
  cargoHash = "sha256-2Ka3n6sT1RUlReNjtV6tMe4ow/M7DFNvWPZktwcEi/w=";
  doInstallCheck = true;

  src = fetchFromGitHub {
    owner = "containers";
    repo = "bootc";
    rev = "v${version}";
    hash = "sha256-vsJwJHPE5Puv9xCnDRDtHzNuFj1U7s1HzZ2vQKTavhs=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libz
    zstd
    openssl
    glib
    ostree
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Boot and upgrade via container images";
    homepage = "https://containers.github.io/bootc";
    license = lib.licenses.mit;
    mainProgram = "bootc";
    maintainers = with lib.maintainers; [ thesola10 ];
    platforms = lib.platforms.linux;
  };
}
