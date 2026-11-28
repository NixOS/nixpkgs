{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "armbian-firmware";
  version = "0-unstable-2026-10-29";

  src = fetchFromGitHub {
    owner = "armbian";
    repo = "firmware";
    rev = "f7fa5956ecca08af42991633a4a8f09d3b1926e5";
    hash = "sha256-cH+re0zE1ihJjOoz/Z9ZIBNJNp1uk9deZGEsMvkoxkU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware
    cp -a * $out/lib/firmware/

    runHook postInstall
  '';

  # Firmware blobs do not need fixing and should not be modified
  dontBuild = true;
  dontFixup = true;

  meta = {
    description = "Firmware from Armbian";
    homepage = "https://github.com/armbian/firmware";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zaldnoay ];
  };
}
