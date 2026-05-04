{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  pipewire,
  udev,
  usbutils,
}:

buildGoModule (finalAttrs: {
  pname = "openlinkhub";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "jurkovic-nikola";
    repo = "OpenLinkHub";
    tag = finalAttrs.version;
    hash = "sha256-yxLRwYsBvwpPVeQWx8R9bfbtdkGu2qUsDiyoijcTD2g=";
  };

  proxyVendor = true;
  vendorHash = "sha256-/itomxsbTDT7ML52bpUfDZIBZ/Rh/zx4Blg+PP7m7gE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    pipewire
    udev
    usbutils
  ];

  env.CGO_CFLAGS_ALLOW = "-fno-strict-overflow";

  installPhase = ''
    runHook preInstall

    install -Dm 644 -t $out/etc/udev/rules.d $src/99-openlinkhub.rules
    install -Dm 755 -t $out/bin $GOPATH/bin/OpenLinkHub

    mkdir -p $out/opt/OpenLinkHub
    cp -r $src/{database,static,web} $out/opt/OpenLinkHub

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/jurkovic-nikola/OpenLinkHub";
    description = "Open source interface for iCUE LINK Hub and other Corsair AIOs, Hubs for Linux";
    changelog = "https://github.com/jurkovic-nikola/OpenLinkHub/releases/tag/${finalAttrs.version}";
    mainProgram = "OpenLinkHub";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      bot-wxt1221
      mikaeladev
    ];
  };
})
