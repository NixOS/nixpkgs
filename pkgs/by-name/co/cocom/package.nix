{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cocom";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "LamdaLamdaLamda";
    repo = "cocom";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-cupe6O/b1aXpve84sv8pW7hrJKMUfWcieM6LwsoRj5o=";
  };

  cargoHash = "sha256-ekgdz95JdWYBUU3pRoCFT7QuagXHEjl5rLoW8CrLVdw=";

  # Tests require network access
  doCheck = false;

  meta = {
    description = "NTP client";
    homepage = "https://github.com/LamdaLamdaLamda/cocom";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cocom";
  };
})
