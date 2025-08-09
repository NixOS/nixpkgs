{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  plymouth,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "asahi-plymouth-theme";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "asahi-plymouth";
    tag = finalAttrs.version;
    hash = "sha256-ljb0eTN9vqC8OCh+HsbwO33HvcnORhMP1o+8xV3y/UM=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 asahi/* -t $out/share/plymouth/themes/asahi

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    substituteInPlace $out/share/plymouth/themes/asahi/asahi.plymouth \
       --replace-fail "/usr" "$out"

    runHook postFixup
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Plymouth theme for Asahi Linux on Apple Silicon Macs";
    homepage = "https://github.com/AsahiLinux/asahi-plymouth";
    license = with lib.licenses; [
      # Plymouth theme code
      gpl3Plus
      # Asahi Linux logo was created by soundflora* and Hector Martin
      cc-by-sa-40
    ];
    maintainers = with lib.maintainers; [ normalcea ];
    platforms = plymouth.meta.platforms;
  };
})
