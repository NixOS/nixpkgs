{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "mdpls";
  version = "0-unstable-2025-08-06";

  src = fetchFromGitHub {
    owner = "euclio";
    repo = "mdpls";
    rev = "329a63d045497a7af3371eefd828424a67ca5d61";
    hash = "sha256-FIPEkuPUJJlhBG8jGKXctJp+HpymzKOF91RXBCSsKPE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = {
    description = "Markdown preview language server";
    homepage = "https://github.com/euclio/mdpls";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ heisfer ];
    mainProgram = "mdpls";
  };
}
