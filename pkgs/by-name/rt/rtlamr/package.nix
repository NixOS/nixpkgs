{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "rtlamr";
  version = "0.9.3-unstable-2023-08-13";

  src = fetchFromGitHub {
    owner = "bemasher";
    repo = "rtlamr";
    rev = "dcdddc5a6e7717a038e9346d0adcf9669e4f60b7";
    sha256 = "sha256-r3dMCpNBCQsqSlFYYfOtVMMgPOagWks6PPWOn5PsLZs";
  };

  vendorHash = "sha256-uT6zfsWgIot0EMNqwtwJNFXN/WaAyOGfcYJjuyOXT4g=";

  meta = {
    description = "Rtl-sdr receiver for Itron ERT compatible smart meters";
    longDescription = ''
      An rtl-sdr receiver for Itron ERT compatible smart meters operating
      in the 900MHz ISM band
    '';
    homepage = "https://github.com/bemasher/rtlamr";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jmendyk ];
    platforms = lib.platforms.unix;
  };
}
