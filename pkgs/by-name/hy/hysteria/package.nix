{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "hysteria";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "HyNetworks";
    repo = "hysteria";
    rev = "app/v${finalAttrs.version}";
    hash = "sha256-3kT55U5nok+o7a6zbrRwTfQS1QwQsXIyyv4hQko6Wi0=";
  };

  vendorHash = "sha256-j/2eOgbFwMdFMwL43OsfX5Yj5zk5VebrwiTquTmcFNI=";
  proxyVendor = true;

  ldflags =
    let
      cmd = "github.com/apernet/hysteria/app/cmd";
    in
    [
      "-s"
      "-w"
      "-X ${cmd}.appVersion=${finalAttrs.version}"
      "-X ${cmd}.appType=release"
    ];

  postInstall = ''
    mv $out/bin/app $out/bin/hysteria
  '';

  # Network required
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feature-packed proxy & relay utility optimized for lossy, unstable connections";
    homepage = "https://github.com/HyNetworks/hysteria";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "hysteria";
  };
})
