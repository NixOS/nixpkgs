{
  buildGoModule,
  fetchFromGitHub,
  lib,
  wirelesstools,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "ivpn";
  version = "3.15.6";

  buildInputs = [ wirelesstools ];

  src = fetchFromGitHub {
    owner = "ivpn";
    repo = "desktop-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C24klcr10i0lki74eNfJ4bappdIttp3S4FGg1wkAGcY=";
  };

  __structuredAttrs = true;

  modRoot = "cli";
  vendorHash = "sha256-Qm3OZq3W8GyfkYP674Jzse7wDPWgXfc0bi8ZpYl4T1I=";

  proxyVendor = true; # .c file

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ivpn/desktop-app/daemon/version._version=${finalAttrs.version}"
    "-X github.com/ivpn/desktop-app/daemon/version._time=1970-01-01"
  ];

  postInstall = ''
    mv $out/bin/{cli,ivpn}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official IVPN Desktop app";
    homepage = "https://www.ivpn.net/apps";
    changelog = "https://github.com/ivpn/desktop-app/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      kilyanni
    ];
    mainProgram = "ivpn";
  };
})
