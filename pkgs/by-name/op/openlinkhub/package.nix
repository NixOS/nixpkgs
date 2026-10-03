{
  lib,
  buildGoModule,
  coreutils,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
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

    install -Dm 755 ${./provision.sh} $out/libexec/openlinkhub-provision
    install -Dm 755 ${./launcher.sh} $out/bin/OpenLinkHub
    substituteInPlace $out/libexec/openlinkhub-provision \
      --replace-fail '@coreutils@' '${coreutils}/bin' \
      --replace-fail '@version@' '${finalAttrs.version}' \
      --replace-fail '@out@' "$out"
    substituteInPlace $out/bin/OpenLinkHub \
      --replace-fail '@coreutils@' '${coreutils}/bin' \
      --replace-fail '@out@' "$out"

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) openlinkhub; };
    assets = {
      static = "${finalAttrs.finalPackage}/opt/OpenLinkHub/static";
      web = "${finalAttrs.finalPackage}/opt/OpenLinkHub/web";
      database = "${finalAttrs.finalPackage}/opt/OpenLinkHub/database";
    };
    provision = "${finalAttrs.finalPackage}/libexec/openlinkhub-provision";
  };

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
