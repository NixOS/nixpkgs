{
  buildGoModule,
  fetchFromGitHub,
  lib,
  wirelesstools,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "ivpn";
  version = "3.15.13";

  buildInputs = [ wirelesstools ];

  src = fetchFromGitHub {
    owner = "ivpn";
    repo = "desktop-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F5MhJ09ioqL4Xf4r2cdXUKmkK8ebj/qRFWfxKuodH3k=";
  };

  __structuredAttrs = true;

  modRoot = "cli";
  vendorHash = "sha256-Q3CbeKrenZr1kGFhSrXW7dcnn3iGKWhWO2qofqAFwgk=";

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
