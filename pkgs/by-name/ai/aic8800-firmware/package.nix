{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  name = "aic8800-firmware";
  version = "4.0+git20250410.b99ca8b6-4deepin2";

  src = fetchFromGitHub {
    owner = "deepin-community";
    repo = "aic8800";
    rev = finalAttrs.version;
    hash = "sha256-6MRfsuz+dzBvcmZ1gx1h8S/Xjr05ZbLftgb3RJ7Kp3k=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/aic8800_fw/
    cp -rv firmware/* $out/lib/firmware/aic8800_fw/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/deepin-community/aic8800";
    description = "Aicsemi aic8800 Wi-Fi driver firmware";
    # Yes, it's unfree. The vendor doesn't provide a redistributable license.
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ Cryolitia ];
    platforms = lib.platforms.linux;
  };
})
