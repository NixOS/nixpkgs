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
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "jurkovic-nikola";
    repo = "OpenLinkHub";
    tag = version;
    hash = "sha256-xcP/Ze9Ba0uYzjCvcx3awij2zA7O8Iu1nbEd/mfeS0w=";
  };

  proxyVendor = true;

  vendorHash = "sha256-LbSSkyIiHCAV4V43GpaaDkLpKAcRdEuHri+s86kWXDc=";

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
