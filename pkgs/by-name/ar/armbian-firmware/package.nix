{ stdenvNoCC, lib, fetchFromGitHub }:
stdenvNoCC.mkDerivation rec {
  pname = "armbian-firmware";
  version = "unstable-2024-08-15";

  src = fetchFromGitHub {
    owner = "armbian";
    repo = "firmware";
    rev = "511deee7289cb9a5dee6ba142d18a09933d5ba00";
    hash = "sha256-l5/SEwrkM3nt7/xj1ejAaRwXIvYdlD5Yn8377paBq/k=";
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

  meta = with lib; {
    description = "Firmware from Armbian";
    homepage = "https://github.com/armbian/firmware";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ zaldnoay ];
  };
}
