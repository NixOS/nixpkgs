{
  buildGoModule,
  lib,
  fetchFromGitHub,
  udev,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "openlinkhub";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "jurkovic-nikola";
    repo = "OpenLinkHub";
    tag = version;
    hash = "sha256-67dnZr83QCAy7fWrrbdSV3Yh8ProewZsL6Gv8Bnc3f4=";
  };

  proxyVendor = true;

  vendorHash = "sha256-nDE3GUZl5OBSlhRpJBixUbWhhFMeieidNrSIzOOB/9g=";

  buildInputs = [
    udev
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/jurkovic-nikola/OpenLinkHub";
    platforms = lib.platforms.linux;
    description = "Open source interface for iCUE LINK Hub and other Corsair AIOs, Hubs for Linux";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.gpl3Only;
    mainProgram = "OpenLinkHub";
    changelog = "https://github.com/jurkovic-nikola/OpenLinkHub/releases/tag/${version}";
  };
}
