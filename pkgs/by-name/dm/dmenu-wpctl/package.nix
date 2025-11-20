{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dmenu-wpctl";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "iamanaws";
    repo = "dmenu-wpctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D0KtmaqTgWajustGI4QrLOj0G9GgMmMGtCShaLJu7lI=";
  };

  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./dmenu-wpctl
    chmod +x $out/bin/dmenu-wpctl

    runHook postInstall
  '';

  meta = {
    description = "Audio/Video control menu for WirePlumber";
    longDescription = ''
      Interactive menu interface to manage audio and video devices
      using wpctl (WirePlumber) and dmenu-compatible programs.
    '';
    homepage = "https://github.com/iamanaws/dmenu-wpctl";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "dmenu-wpctl";
    platforms = lib.platforms.linux;
  };
})
