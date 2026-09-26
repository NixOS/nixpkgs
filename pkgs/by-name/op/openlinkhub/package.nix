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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "jurkovic-nikola";
    repo = "OpenLinkHub";
    tag = finalAttrs.version;
    hash = "sha256-MIr37WrS3DoBL1gdzUkXugX8KksUA3x5pTsh5+6VBXs=";
  };

  proxyVendor = true;
  vendorHash = "sha256-d0tA2XVDF/PzmBKqBSjfKJ3C3Lt0gMi3i2bx5LKRgj8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    pipewire
    udev
    usbutils
  ];

  env.CGO_CFLAGS_ALLOW = "-fno-strict-overflow";

  installPhase = ''
    runHook preInstall

    install -Dm 644 -t $out/etc/udev/rules.d 99-openlinkhub.rules
    install -Dm 755 -t $out/opt/OpenLinkHub $GOPATH/bin/OpenLinkHub

    cp -rt $out/opt/OpenLinkHub database static web

    mkdir -p $out/bin
    ln -st $out/bin $out/opt/OpenLinkHub/OpenLinkHub

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
