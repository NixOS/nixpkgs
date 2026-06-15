{
  buildGoModule,
  lib,
  fetchFromGitHub,
  pkg-config,
  pipewire,
  udev,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "openlinkhub";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "jurkovic-nikola";
    repo = "OpenLinkHub";
    tag = version;
    hash = "sha256-uYuhmvdHNVs19egakwDOvIJ2IEAeZEAV6qgMYEl+Ie4=";
  };

  proxyVendor = true;

  vendorHash = "sha256-/itomxsbTDT7ML52bpUfDZIBZ/Rh/zx4Blg+PP7m7gE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
    pipewire
  ];

  env = {
    CGO_ENABLED = "1";
    CGO_CFLAGS_ALLOW = "-fno-strict-overflow";
  };

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
