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
  version = "1.1.2";
  cargoHash = "sha256-i8eYypTgm43Ib1HZ2e9WBLUyDAGCZPpvpzmjTS8d9e0=";
  doInstallCheck = true;

  src = fetchFromGitHub {
    owner = "containers";
    repo = "bootc";
    rev = "v${version}";
    hash = "sha256-p1+j62MllmPcvWnijieSZmlgwYy76X17fv12Haetz78=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libz
    zstd
    openssl
    glib
    ostree-full
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
