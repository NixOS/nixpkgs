{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "armbian-firmware";
  version = "0-unstable-2023-09-16";

  src = fetchFromGitHub {
    owner = "armbian";
    repo = "firmware";
    rev = "01f9809bb0c4bd60c0c84b9438486b02d58b03f7";
    hash = "sha256-ozKADff7lFjIT/Zf5dkNlCe8lOK+kwYb/60NaCJ8i2k=";
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
